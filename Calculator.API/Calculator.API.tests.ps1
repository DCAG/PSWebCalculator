Describe "Caluclator" {
    $UriHost = 'localhost'
    $UriPort = 8080
    $UriRoot = "http://$UriHost`:$UriPort"
    Context "Connections" {
        It "Endpoint is accessible" {
            Test-Connection $UriHost -TCPPort $UriPort
        }
    }

    Context "Operations" {
        $TestCases = @(
            @{op='add';sign='+';a=1;b=1;r=2}
            @{op='add';sign='+';a=2;b=2;r=4}
            @{op='add';sign='+';a=0;b=3;r=3}
            @{op='add';sign='+';a=9;b=3;r=12}
            @{op='add';sign='+';a=7;b=1;r=8}
            @{op='add';sign='+';a=1;b=2;r=3}
            @{op='add';sign='+';a=23;b=46;r=69}
            @{op='add';sign='+';a=100;b=10;r=110}

            @{op='mul';sign='*';a=1;b=1;r=1}
            @{op='mul';sign='*';a=2;b=2;r=4}
            @{op='mul';sign='*';a=0;b=3;r=0}
            @{op='mul';sign='*';a=9;b=3;r=27}
            @{op='mul';sign='*';a=7;b=1;r=7}
            @{op='mul';sign='*';a=1;b=2;r=2}
            @{op='mul';sign='*';a=23;b=46;r=1058}
            @{op='mul';sign='*';a=100;b=10;r=1000}

            @{op='div';sign='/';a=1;b=1;r=1}
            @{op='div';sign='/';a=2;b=2;r=1}
            @{op='div';sign='/';a=0;b=3;r=0}
            @{op='div';sign='/';a=9;b=3;r=3}
            @{op='div';sign='/';a=7;b=1;r=7}
            @{op='div';sign='/';a=1;b=2;r=0.5}
            @{op='div';sign='/';a=23;b=46;r=0.5}
            @{op='div';sign='/';a=100;b=10;r=10}

            @{op='sub';sign='-';a=1;b=1;r=0}
            @{op='sub';sign='-';a=2;b=2;r=0}
            @{op='sub';sign='-';a=0;b=3;r=-3}
            @{op='sub';sign='-';a=9;b=3;r=6}
            @{op='sub';sign='-';a=7;b=1;r=6}
            @{op='sub';sign='-';a=1;b=2;r=-1}
            @{op='sub';sign='-';a=23;b=46;r=-23}
            @{op='sub';sign='-';a=100;b=10;r=90}
        )

        It "<op>: <a> <sign> <b> = <r>" -TestCases $TestCases {
            param($op, $a, $b, $r)

            Write-Verbose "Invoke-RestMethod '$UriRoot/$op`?a=$a&b=$b'" -Verbose
            $res = Invoke-RestMethod "$UriRoot/$op`?a=$a&b=$b"
            $res.result | Should -Be "$r"
        }
    }
}