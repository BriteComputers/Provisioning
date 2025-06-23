function Install-Navisworks {

    $DownloadURL = "https://dds.autodesk.com/NetSWDLD/ODIS/prd/2026/NAVFREE/BE06C262-73A9-3C2F-8982-C105E1EE9A34/SFX/Autodesk_Navisworks_Freedom_2026_Win_64bit_db.sfx.exe"
    $DownloadPath = "$Global:Basepath\Apps\Navisworks"
    $DownloadFile = "$DownloadPath\Navisworks-Installer.exe"

    Write-Log "Starting DWG TrueView installation."

    # Ensure download directory exists
    if (!(Test-Path $DownloadPath)) {
        try {
            New-Item -ItemType "Directory" -Path $DownloadPath -Force | Out-Null
            Write-Log "Created directory $DownloadPath."
        } catch {
            Write-Log "Failed to create directory ${$DownloadPath}: $($_.Exception.Message)" -Type "ERROR"
            return
        }
    }

    Write-Log "Downloading DWG TrueView from $DownloadURL"
    $ProgressPreference = 'SilentlyContinue'
    try {
        Invoke-WebRequest $DownloadURL -OutFile $DownloadFile
        Write-Log "DWG TrueView downloaded to $DownloadFile."
    } catch {
        Write-Log "Failed to download DWG TrueView: $($_.Exception.Message)" -Type "ERROR"
        return
    }

    Write-Log "Running DWG TrueView installer from $DownloadFile"
    try {
        Start-Process $DownloadFile -ArgumentList "-q" -Wait
        Write-Log "DWG TrueView installed successfully."
    } catch {
        Write-Log "Failed to install DWG TrueView: $($_.Exception.Message)" -Type "ERROR"
        return
    }

    Write-Log "Install-Navisworks function completed."
}