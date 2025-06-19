function Start-Logon3 {

    Write-Host "Import Functions"

    $progressPreference = 'silentlyContinue'

    $Global:BasePath = "C:\ProgramData\Deployment"

    Start-PPKGLog Logon3

    Update-WindowTitle -PassNumber 3

    $Config = Import-Config

    $SecurePassword = $Config.Password | ConvertTo-SecureString

    $global:SiteCode = $Config.Sitecode

    Set-ProtectionPolicy

    Install-Agent -Token $Config.Token -Domain $Config.Domain

    Update-Windows

    if ($Config.Vpn.Name -eq "GlobalProtect") {
        Install-GlobalProtect -Portal $Config.Vpn.Server
    }

    Set-AutoLogon -Username $Config.Username -Password $SecurePassword

    Read-Host “`nProvision packge is complete.`nPress ENTER to reboot so you can start testing...”

    Stop-Transcript

    Remove-PPKGInstallFolder

}