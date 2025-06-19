function Start-Logon2 {

    Start-Sleep -Seconds 15

    Write-Host "Import Functions"

    $progressPreference = 'silentlyContinue'

    $Global:BasePath = "C:\ProgramData\Deployment"

    $global:SiteCode = $Config.Sitecode

    Start-PPKGLog Logon2

    Update-WindowTitle -PassNumber 2

    $Config = Load-Config

    $SecurePassword = $Config.Password | ConvertTo-SecureString

    Install-Apps

    Update-Windows -HideUpdates "Yes"

    Set-AutoLogon -Username $Config.Username -Password $SecurePassword

    Set-RunOnce -Label "Logon3"

    Write-Host "Restarting Computer"

    Start-Sleep -Seconds 10

    Stop-transcript

    Restart-Computer -Force
    
}