Function Connect-VPN{
    param
        (
            [ValidateSet('WindowsVPN','Netextender')]			
            [Parameter(Mandatory=$True)]
            [string]$VPNType,

            [Parameter(Mandatory=$True)]
            [string]$IPAddress,

            [Parameter(Mandatory=$False)]
            [string]$Domain,

            [Parameter(Mandatory=$True)]
            [string]$Username,

            [Parameter(Mandatory=$True)]
            [string]$Password,

            [Parameter(Mandatory=$False)]
            [string]$Name
        )

    If($VPNType -eq "WindowsVPN"){
        Start-Process rasdial -NoNewWindow -ArgumentList "$Name $Username $Password" -PassThru -Wait
    }
    IF($VPNType -eq "Netextender"){

        Start-Process -FilePath "C:\Program Files (x86)\SonicWall\SSL-VPN\NetExtender\NECLI.exe" -ArgumentList "connect -s $IPAddress -d $Domain -u $Username -p $Password --always-trust"
    }
    Else{
        Write-Host "VPN connection not set up yet"
    }
}