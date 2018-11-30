#requires -module Polaris

# ref: https://github.com/PowerShell/Polaris/tree/master/docs
# error codes ref: https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html

Remove-PolarisRoute

Clear-Polaris

$Scriptblock = {
    $operands = 'a', 'b'
    foreach($operand in $operands) {
        if ($null -ne $request.Query[$operand] -and $request.Query[$operand] -match '^[-+]?(0|(\d\.\d|[1-9])\d*)$') {
            Invoke-Expression "[int]`$$operand = $($request.Query[$operand])" 
        }
        else {    
            $response.SetStatusCode(400);
            $json = @{
                a      = $null
                b      = $null
                data   = '${0} = {1}' -f $operand, $request.Query[$operand]
                result = 'The request could not be understood by the server due to malformed syntax. The client SHOULD NOT repeat the request without modifications.'
            }

            $response.Json((ConvertTo-Json -InputObject $json))
            return
        }
    }

    $json = @{
        a = $a
        b = $b
        result = Invoke-Expression "$a <op> $b"
    }

    $response.Json((ConvertTo-Json -InputObject $json))   
}

@(
    @{Path = '/add'; op = '+'} # Add
    @{Path = '/mul'; op = '*'} # Multiply
    @{Path = '/sub'; op = '-'} # Substruct
    @{Path = '/div'; op = '/'} # Divide
) | ForEach-Object {
    New-PolarisRoute -Path $_.Path -Method GET -Scriptblock ([scriptblock]::Create(($Scriptblock.ToString() -replace '\<op\>', $_.op))) 
}

New-PolarisRoute -Path "/api/v1/status" -Method GET -Scriptblock {
    $Response.Send('OK'); 
}

if($Polaris){
    Stop-Polaris -ServerContext $Polaris
}

$Polaris = Start-Polaris -Port 8080