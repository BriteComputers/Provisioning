function Set-AutoLogon {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Username,

        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )

    Write-Host "Set autologon"

    # Convert SecureString to plain text safely in memory
    $PlainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    )

    # Registry path
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

    # Set registry values
    Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -Type String
    Set-ItemProperty $RegPath "DefaultUsername" -Value $Username -Type String
    Set-ItemProperty $RegPath "DefaultPassword" -Value $PlainPassword -Type String
    Set-ItemProperty $RegPath "AutoLogonCount" -Value "1" -Type DWord

    $PlainPassword = $null
    [System.GC]::Collect()

    Write-Host "End of Set autologon"
}