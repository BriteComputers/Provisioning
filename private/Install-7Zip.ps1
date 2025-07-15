$LogPath = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\7ZipInstall.log"
$DowloadPath = "https://7-zip.org/a/7z2301-x64.exe"
$TempPath = "C:\7Zip-Temp"
$DownloadFile = "7Zip-Installer.exe"
$DownloadPath = "$TempPath\$DownloadFile"

Start-Transcript -path $LogPath -Force -Append

Write-Host "7Zip is not installed. Downloading latest version..."
mkdir  $TempPath
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest $DowloadPath -OutFile $DownloadPath
Write-Host "7Zip is downloaded. Installing..."
Start-Process $DownloadPath -ArgumentList "/S" -wait
Start-Sleep -Seconds 5
Remove-Item $TempPath -Force -Recurse

Stop-transcript