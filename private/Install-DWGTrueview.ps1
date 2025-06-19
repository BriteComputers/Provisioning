function Install-DWGTrueview {

    $DownloadURL = "https://efulfillment.autodesk.com/NetSWDLD/2024/ACD/9C02048D-D0DB-3E06-B903-89BD24380AAD/SFX/DWGTrueView_2024_English_64bit_dlm.sfx.exe"
    $DownloadPath = "$Global:Basepath\Apps\DWGTrueView"
    $DownloadFile = "$DownloadPath\DWGTrueView-Installer.exe"
    $SetupPath = "C:\Autodesk\DWGTrueView_2024_English_64bit_dlm\Setup.exe"

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

    Write-Log "Extracting DWG TrueView files..."
    try {
        Start-Process $DownloadFile -ArgumentList "-suppresslaunch -d C:\Autodesk" -Wait
        Write-Log "DWG TrueView files extracted to C:\Autodesk."
    } catch {
        Write-Log "Failed to extract DWG TrueView files: $($_.Exception.Message)" -Type "ERROR"
        return
    }

    Start-Sleep -Seconds 5

    Write-Log "Running DWG TrueView installer from $SetupPath"
    try {
        Start-Process $SetupPath -ArgumentList "--silent" -Wait
        Write-Log "DWG TrueView installed successfully."
    } catch {
        Write-Log "Failed to install DWG TrueView: $($_.Exception.Message)" -Type "ERROR"
        return
    }

    Write-Log "Install-DWGTrueview function completed."
}