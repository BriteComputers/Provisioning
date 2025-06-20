function Start-Logon2 {

    Write-Host "Import Functions"

    $progressPreference = 'silentlyContinue'

    $Global:BasePath = "C:\ProgramData\Deployment"

    Start-PPKGLog Logon2

    Update-WindowTitle -PassNumber 2

    $Config = Import-Config

    $global:SiteCode = $Config.Sitecode

    $SecurePassword = $Config.Password | ConvertTo-SecureString

    Install-Apps

    Update-Windows -HideCumulativeUpdates "Yes"

    Set-AutoLogon -Username $Config.Username -Password $SecurePassword

    Set-RunOnce -Label "Logon3"

    Write-Host "Restarting Computer"

    Start-Sleep -Seconds 10

    Stop-transcript

    Restart-Computer -Force
    
}