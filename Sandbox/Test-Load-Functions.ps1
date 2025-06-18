$repo = "BriteComputers/Provisioning"
$repoUrl = "https://github.com/$repo/archive/refs/heads/main.zip"
$ModuleName = "BriteProvisioning"

# Define where to install it
$installPath = "C:\Program Files\WindowsPowerShell\Modules\$ModuleName"

# Temp paths
$tempZip = "$env:TEMP\$ModuleName.zip"
$tempExtractPath = "$env:TEMP\$ModuleName-Extract"

# Download
Write-Host "⬇Downloading $repoUrl..."
Invoke-WebRequest -Uri $repoUrl -OutFile $tempZip -UseBasicParsing

# Unzip
Write-Host "Extracting..."
Expand-Archive -Path $tempZip -DestinationPath $tempExtractPath -Force

# Determine source folder inside ZIP (GitHub adds suffix like "-main" or "-v1.0.0")
$innerFolder = Get-ChildItem $tempExtractPath | Where-Object { $_.PSIsContainer } | Select-Object -First 1

# Copy to modules folder
Write-Host "Installing to $installPath..."
if (Test-Path $installPath) { Remove-Item $installPath -Recurse -Force }
Copy-Item -Path $innerFolder.FullName -Destination $installPath -Recurse

# Clean up
Remove-Item $tempZip -Force
Remove-Item $tempExtractPath -Recurse -Force