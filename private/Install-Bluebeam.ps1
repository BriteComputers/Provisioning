$DownloadURL = "https://www.bluebeam.com/MSIdeployx64"
$DownloadPath = "$Global:BasePath\Apps\BlueBeam"
$DownloadFile = Join-Path -Path $DownloadPath -ChildPath "BlueBeam-Installer.zip"
$OCRFile = Join-Path -Path $DownloadPath -ChildPath "BluebeamOCR x64 21.msi"
$BBMSI = Join-Path -Path $DownloadPath -ChildPath "Bluebeam Revu x64 21.msi"

# Start logging
Write-Log "Starting BlueBeam installation process."

# Ensure the directory exists
Write-Log "Creating directory ${DownloadPath} if it does not exist."
if (-not (Test-Path $DownloadPath)) {
    try {
        New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null
        Write-Log "directory ${DownloadPath} created successfully."
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Failed to create directory ${DownloadPath}: $errorMessage" -Type "ERROR"
        throw
    }
}

# Download BlueBeam installer
Write-Log "Downloading BlueBeam installer from $DownloadURL."
$ProgressPreference = 'SilentlyContinue'
try {
    Invoke-WebRequest -Uri $DownloadURL -OutFile $DownloadFile
    Write-Log "BlueBeam installer downloaded successfully to ${DownloadFile}."
} catch {
    $errorMessage = $_.Exception.Message
    Write-Log "Failed to download BlueBeam installer: $errorMessage" -Type "ERROR"
    throw
}

# Extract the installer
Write-Log "Extracting BlueBeam installer from ${DownloadFile}."
try {
    Expand-Archive -Path $DownloadFile -DestinationPath $DownloadPath -Force
    Write-Log "BlueBeam installer extracted successfully to ${DownloadPath}."
} catch {
    $errorMessage = $_.Exception.Message
    Write-Log "Failed to extract BlueBeam installer: $errorMessage" -Type "ERROR"
    throw
}

# Rename installer files
Write-Log "Renaming installer files."
try {
    Rename-Item -Path $OCRFile -NewName "BluebeamOCR-Installer.msi"
    Rename-Item -Path $BBMSI -NewName "Bluebeam-Installer.msi"
    Write-Log "Installer files renamed successfully."
} catch {
    $errorMessage = $_.Exception.Message
    Write-Log "Failed to rename installer files: $errorMessage" -Type "ERROR"
    throw
}

# Install BlueBeam OCR
Write-Log "Installing BlueBeam OCR from ${DownloadPath}\BluebeamOCR-Installer.msi."
try {
    Start-Process msiexec.exe -ArgumentList "/i $DownloadPath\BluebeamOCR-Installer.msi /qn /passive /norestart" -Wait
    Write-Log "BlueBeam OCR installed successfully."
} catch {
    $errorMessage = $_.Exception.Message
    Write-Log "Failed to install BlueBeam OCR: $errorMessage" -Type "ERROR"
    throw
}

# Install BlueBeam Revu
Write-Log "Installing BlueBeam Revu from ${DownloadPath}\Bluebeam-Installer.msi."
try {
    Start-Process msiexec.exe -ArgumentList "/i $DownloadPath\Bluebeam-Installer.msi /qn /passive /norestart DISABLE_WELCOME=1" -Wait
    Write-Log "BlueBeam Revu installed successfully."
} catch {
    $errorMessage = $_.Exception.Message
    Write-Log "Failed to install BlueBeam Revu: $errorMessage" -Type "ERROR"
    throw
}

# Clean up temporary files
Write-Log "Cleaning up temporary files in ${DownloadPath}."
try {
    Remove-Item -Path $DownloadPath -Recurse -Force
    Write-Log "Temporary files removed successfully."
} catch {
    $errorMessage = $_.Exception.Message
    Write-Log "Failed to remove temporary files: $errorMessage" -Type "ERROR"
    throw
}

Write-Log "BlueBeam installation process completed."