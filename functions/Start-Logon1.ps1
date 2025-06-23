function Start-Logon1 {

    Write-Host "Import Functions"

    $progressPreference = 'silentlyContinue'

    $Global:BasePath = "C:\ProgramData\Deployment"

    Start-PPKGLog Logon1

    Update-WindowTitle -PassNumber 1

    Convert-AESPasswordToDPAPI

    $Config = Import-Config

    $global:SiteCode = $Config.Sitecode

    $SecurePassword = $Config.Password | ConvertTo-SecureString

    Disable-FastStartup

    Set-NoSleep

    Set-ESTTime

    Update-Windows -HideCumulativeUpdates "Yes"

    Set-AutoLogon -Username $Config.Username -Password $SecurePassword

    Set-RunOnce -Label "Logon2" 

    Write-Host "Restarting Computer"

    Start-Sleep -Seconds 10

    Stop-transcript

    Restart-Computer -Force 
    
}