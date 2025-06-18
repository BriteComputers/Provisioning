function Install-Teams{

    $DownloadURL = "https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true"
    $DownloadPath = "$Global:BasePath\TeamsInstaller.msi"

    Write-Host "Downloading Teams"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest $DownloadURL -OutFile $DownloadPath
    Write-Host "Installing Teams"
    Start-Process MsiExec.exe -ArgumentList "/i $DownloadPath /qn /norestart" -Wait
    Write-Host "Teams Installed"
    
}