#requires -module UniversalDashboard.Community

# ref: https://docs.universaldashboard.io/components/inputs

$MyDashboard = New-UDDashboard -Title "Calculator" -Content {
    New-UDLayout -Columns 2 -Content {  
        New-UDTextbox -Id 'a' -Placeholder '1st operand' -Label '1st operand'
        New-UDTextbox -Id 'b' -Placeholder '2nd operand' -Label '2nd operand'
    }

    $ScriptBlock = {
        $aOperand = Get-UDElement -Id 'a'
        $bOperand = Get-UDElement -Id 'b'
        $a = $aOperand.Attributes.value
        $b = $bOperand.Attributes.value
        try {
            $res = Invoke-RestMethod "http://localhost:8080/<op>?a=$a&b=$b"
            Set-UDElement -Id "result" -Content { $res.result }
        }catch{
            $Message = "{0}`n{1}" -f $_.Exception.Message, ($_.ErrorDetails.Message | ConvertFrom-Json)
            Show-UDToast -Message $Message -MessageColor red -Duration 20000
        }
    }
    
    New-UDLayout -Columns 2 -Content {  
        @(
            @{Path = 'add'; Text = '+'} # Add
            @{Path = 'sub'; Text = '-'} # Substruct
            @{Path = 'mul'; Text = 'X'} # Multiply
            @{Path = 'div'; Text = '/'} # Divide
        ) | ForEach-Object {
            New-UDButton -Text $_.Text -Id $_.Path -OnClick ([scriptblock]::Create(($Scriptblock.ToString() -replace '\<op\>', $_.Path))) 
        }
    }

    New-UDLayout -Columns 3 -Content {
        New-UDHeading -Size 5 -Text ""
        New-UDCard -Content {
            New-UDHeading -Size 5 -Id "result" -Text ""
        } -TextAlignment center
        New-UDHeading -Size 5 -Text ""
    }
}
​
#Get-UDDashboard | Stop-UDDashboard
Start-UDDashboard -Port 8081 -Dashboard $MyDashboard -AutoReload
# Stop-UDDashboard -Port 8081