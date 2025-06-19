function Install-ShareFile {

    Write-Log "Starting Install-ShareFile function."

    $DownloadURL = "https://dl.sharefile.com/sfwin-msi"
    $DownloadPath = "$Global:Basepath\Apps\ShareFile"
    $DownloadFile = "$DownloadPath\ShareFile-Installer.msi"

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

    Write-Log "Downloading ShareFile from $DownloadURL"
    $ProgressPreference = 'SilentlyContinue'
    try {
        Invoke-WebRequest $DownloadURL -OutFile $DownloadFile
        Write-Log "Downloaded ShareFile installer to $DownloadFile."
    } catch {
        Write-Log "Failed to download ShareFile: $($_.Exception.Message)" -Type "ERROR"
        return
    }

    Write-Log "Installing ShareFile from $DownloadFile"
    try {
        Start-Process msiexec.exe -ArgumentList "/i $DownloadFile /qn" -Wait
        Write-Log "ShareFile installed successfully."
    } catch {
        Write-Log "Failed to install ShareFile: $($_.Exception.Message)" -Type "ERROR"
        return
    }

    Write-Log "Install-ShareFile function completed."
}