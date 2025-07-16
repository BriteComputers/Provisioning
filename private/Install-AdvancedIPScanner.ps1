Function Install-AdvancedIPScanner{
    
    $InstallerUrl = "https://download.advanced-ip-scanner.com/download/files/Advanced_IP_Scanner_2.5.4594.1.exe"
    $DownloadPath = "C:\ProgramData\Deployment\Apps"
    $InstallerFile = Join-Path -Path $DownloadPath -ChildPath "AdvancedIPScanner-Installer.exe"

    # Start logging
    Write-Log "Starting AdvancedIPScanner installation process."

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

    Write-Log "Downloading AdvancedIPScanner from $InstallerUrl"
    $ProgressPreference = 'SilentlyContinue'
    try {
        Invoke-WebRequest -Uri $InstallerUrl -OutFile $InstallerFile
        Write-Log "AdvancedIPScanner downloaded successfully to ${InstallerFile}."
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Failed to download AdvancedIPScanner: $errorMessage" -Type "ERROR"
        throw
    }

    Write-Log "Installing AdvancedIPScanner from ${InstallerFile}"
    try {
        &$InstallerFile /VERYSILENT /NORESTART |Wait-Process

        Write-Log "AdvancedIPScanner installed successfully."
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Failed to install AdvancedIPScanner: $errorMessage" -Type "ERROR"
        throw
    }

    Write-Log "AdvancedIPScanner installation process completed. Stopping Program"
    Stop-Process -Name advanced_ip_scanner
    
}