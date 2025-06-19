function Install-AnyVideoConverter {

    $LogPath = "C:\ProgramData\Deployment\Logs\AVCDeployment.log"
    $DownloadURL = "https://www.any-video-converter.com/avc-free.exe"
    $DownloadPath = "C:\ProgramData\Deployment\Apps\AVC"
    $InstallerFile = Join-Path -Path $DownloadPath -ChildPath "AVC-Installer.exe"

    # Ensure the log directory exists
    $LogDirectory = Split-Path -Path $LogPath -Parent
    if (-not (Test-Path $LogDirectory)) {
        New-Item -Path $LogDirectory -ItemType Directory -Force | Out-Null
    }

    # Start logging
    Write-Log "Starting AVC installation process."

    Write-Log "Creating directory ${DownloadPath} if it does not exist."
    if (-not (Test-Path $DownloadPath)) {
        try {
            New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null
            Write-Log "Directory ${DownloadPath} created successfully."
        } catch {
            $ErrorMessage = $_.Exception.Message
            Write-Log "Failed to create directory ${DownloadPath}: $ErrorMessage" -Type "ERROR"
            throw
        }
    }

    Write-Log "Downloading AVC from $DownloadURL"
    $ProgressPreference = 'SilentlyContinue'
    try {
        Invoke-WebRequest -Uri $DownloadURL -OutFile $InstallerFile
        Write-Log "AVC downloaded successfully to ${InstallerFile}."
    } catch {
        $ErrorMessage = $_.Exception.Message
        Write-Log "Failed to download AVC: $ErrorMessage" -Type "ERROR"
        throw
    }

    Write-Log "Installing AVC from ${InstallerFile}"
    try {
        Start-Process $InstallerFile -ArgumentList "-s" -Wait
        Write-Log "AVC installed successfully."
    } catch {
        $ErrorMessage = $_.Exception.Message
        Write-Log "Failed to install AVC: $ErrorMessage" -Type "ERROR"
        throw
    }

    Write-Log "AVC installation process completed."
    
}