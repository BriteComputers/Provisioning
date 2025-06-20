function Install-GoToResolve {
    
    $InstallerUrl = "https://cdn.console.gotoresolve.com/dtc/LMIResolveDesktopConsole-x64.msi"
    $DownloadPath = "C:\ProgramData\Deployment\Apps"
    $InstallerFile = Join-Path -Path $DownloadPath -ChildPath "GoToResolve-Installer.msi"

    # Start logging
    Write-Log "Starting GoToResolve installation process."

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

    Write-Log "Downloading GoToResolve from $InstallerUrl"
    $ProgressPreference = 'SilentlyContinue'
    try {
        Invoke-WebRequest -Uri $InstallerUrl -OutFile $InstallerFile
        Write-Log "GoToResolve downloaded successfully to ${InstallerFile}."
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Failed to download GoToResolve: $errorMessage" -Type "ERROR"
        throw
    }

    Write-Log "Installing GoToResolve from ${InstallerFile}"
    try {
        Start-Process msiexec.exe -ArgumentList "/i $InstallerFile /quiet" -Wait
        Write-Log "GoToResolve installed successfully."
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Failed to install GoToResolve: $errorMessage" -Type "ERROR"
        throw
    }

    Write-Log "GoToResolve installation process completed."
    
}
