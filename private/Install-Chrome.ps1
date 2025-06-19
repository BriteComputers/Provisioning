$InstallerUrl = "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi"
$DownloadPath = "C:\ProgramData\Deployment\Apps"
$InstallerFile = Join-Path -Path $DownloadPath -ChildPath "Chrome-Installer.msi"

# Ensure the log directory exists
$LogDirectory = Split-Path -Path $LogPath -Parent
if (-not (Test-Path $LogDirectory)) {
    New-Item -Path $LogDirectory -ItemType Directory -Force | Out-Null
}

# Start logging
Write-Log "Starting Chrome installation process."

Write-Log "Creating directory ${DownloadPath} if it does not exist."
if (-not (Test-Path $DownloadPath)) {
    try {
        New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null
        Write-Log "Directory ${DownloadPath} created successfully."
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Failed to create directory ${DownloadPath}: $errorMessage" -Type "ERROR"
        throw
    }
}

Write-Log "Downloading Chrome from $InstallerUrl"
$ProgressPreference = 'SilentlyContinue'
try {
    Invoke-WebRequest -Uri $InstallerUrl -OutFile $InstallerFile
    Write-Log "Chrome downloaded successfully to ${InstallerFile}."
} catch {
    $errorMessage = $_.Exception.Message
    Write-Log "Failed to download Chrome: $errorMessage" -Type "ERROR"
    throw
}

Write-Log "Installing Chrome from ${InstallerFile}"
try {
    Start-Process msiexec.exe -ArgumentList "/i $InstallerFile /quiet" -Wait
    Write-Log "Chrome installed successfully."
} catch {
    $errorMessage = $_.Exception.Message
    Write-Log "Failed to install Chrome: $errorMessage" -Type "ERROR"
    throw
}

Write-Log "Chrome installation process completed."