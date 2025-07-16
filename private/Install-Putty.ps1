Function Install-Putty{

    $InstallerUrl = "https://the.earth.li/~sgtatham/putty/0.83/w64/putty-64bit-0.83-installer.msi"
    $DownloadPath = "C:\ProgramData\Deployment\Apps"
    $InstallerFile = Join-Path -Path $DownloadPath -ChildPath "Putty-Installer.msi"

    # Start logging
    Write-Log "Starting Putty installation process."

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

    Write-Log "Downloading Putty from $InstallerUrl"
    $ProgressPreference = 'SilentlyContinue'
    try {
        Invoke-WebRequest -Uri $InstallerUrl -OutFile $InstallerFile
        Write-Log "Putty downloaded successfully to ${InstallerFile}."
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Failed to download Putty: $errorMessage" -Type "ERROR"
        throw
    }

    Write-Log "Installing Putty from ${InstallerFile}"
    try {
        Start-Process msiexec.exe -ArgumentList "/i $InstallerFile /qn /norestart" -Wait
        Write-Log "Putty installed successfully."
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Failed to install Putty: $errorMessage" -Type "ERROR"
        throw
    }

    Write-Log "Putty installation process completed."
    
}