Function Install-O365{
    
    $DowloadURL = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_16731-20398.exe"
    $DownloadPath = "$Global:BasePath\Apps\O365"
    $DownloadFile = "$DownloadPath\O365-Installer.exe"
    $O365ConfigDest = "$Global:BasePath\Apps\O365\configuration-Office365-x64.xml"

    if (!(Test-Path $DownloadPath)) {
        New-Item -ItemType "Directory" -Path $DownloadPath
    }
    
    Write-Host "Downloading 365 Apps"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest $DowloadURL -OutFile $DownloadFile
    Write-Host "Extracting Setup.exe file"
    Start-Process $DownloadFile -ArgumentList "/quiet /extract:$DownloadPath" -wait
    
    Write-Host "Installing Office"
    & $DownloadPath\setup.exe /configure $O365ConfigDest | Wait-Process

}
