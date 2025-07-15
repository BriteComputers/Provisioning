function Start-OMConfig {

    Write-Host "Import Functions"

    $progressPreference = 'silentlyContinue'

    $Global:BasePath = "C:\ProgramData\Deployment"

    Install-NotePadPlusPlus

    Install-AdvancedIPScanner

    Install-WinSCP

    Install-Chrome

    Install-Putty

    Install-7Zip

    Update-Windows -HideCumulativeUpdates "Yes"

    Restart-Computer -Force 
    
}