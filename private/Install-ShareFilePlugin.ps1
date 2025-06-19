function Install-ShareFilePlugin {

    Write-Log "Starting Install-ShareFilePlugin function."

    $DownloadURL = "https://dl.sharefile.com/sfo-msi"
    $DownloadPath = "$Global:Basepath\Apps\ShareFile"
    $DownloadFile = "$DownloadPath\SharefilePlugin-Installer.msi"

    # Ensure temp directory exists
    if (!(Test-Path $DownloadPath)) {
        try {
            New-Item -ItemType "Directory" -Path $DownloadPath -Force | Out-Null
            Write-Log "Created directory $DownloadPath."
        } catch {
            Write-Log "Failed to create directory ${$DownloadPath}: $($_.Exception.Message)" -Type "ERROR"
            return
        }
    }

    Write-Log "Downloading ShareFilePlugin from $DownloadURL"
    $ProgressPreference = 'SilentlyContinue'
    try {
        Invoke-WebRequest $DownloadURL -OutFile $DownloadFile
        Write-Log "Downloaded ShareFilePlugin installer to $DownloadFile."
    } catch {
        Write-Log "Failed to download ShareFilePlugin: $($_.Exception.Message)" -Type "ERROR"
        return
    }

    Write-Log "Installing ShareFilePlugin from $DownloadFile"
    try {
        Start-Process msiexec.exe -ArgumentList "/i $DownloadFile /qn" -Wait
        Write-Log "ShareFilePlugin installed successfully."
    } catch {
        Write-Log "Failed to install ShareFilePlugin: $($_.Exception.Message)" -Type "ERROR"
        return
    }

    Write-Log "Install-ShareFilePlugin function completed."
}