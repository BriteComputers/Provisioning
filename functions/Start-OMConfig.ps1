function Start-OMConfig {

    Set-executionPolicy Bypass -Scope Process -Force

    Write-Host "Import Functions"

    $progressPreference = 'silentlyContinue'

    $Global:BasePath = "C:\ProgramData\Deployment"

    Install-NotePadPlusPlus

    Install-AdvancedIPScanner

    Install-WinSCP

    Install-Chrome

    Install-Putty

    Install-7Zip

    #Update-Windows -HideCumulativeUpdates "Yes"

    Set-executionPolicy -Scope Process -ExecutionPolicy Restricted -Force
    
}