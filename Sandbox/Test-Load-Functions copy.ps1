$moduleName = "BriteProvisioning"
$localVersion = (Get-Module -Name $moduleName).Version
$remotePsd1Url = "https://raw.githubusercontent.com/BriteComputers/Provisioning/refs/heads/main/BriteProvisioning.psd1"
$repo = "BriteComputers/Provisioning"
$repoUrl = "https://github.com/$repo/archive/refs/heads/main.zip"
$installPath = "C:\Program Files\WindowsPowerShell\Modules\$ModuleName"
$tempZip = "$env:TEMP\$ModuleName.zip"
$tempExtractPath = "$env:TEMP\$ModuleName-Extract"

try {
    $psd1Content = Invoke-RestMethod -Uri $remotePsd1Url -Headers @{ "User-Agent" = "PowerShell" }
    $tempFile = "$env:TEMP\$moduleName.psd1"
    Set-Content -Path $tempFile -Value $psd1Content -Encoding UTF8

    $remoteManifest = Import-PowerShellDataFile -Path $tempFile
    $remoteVersion = [version]$remoteManifest.ModuleVersion

    Write-Host "Local Version : $localVersion"
    Write-Host "Remote Version: $remoteVersion"

    if ($remoteVersion -gt $localVersion) {
        Write-Host "Update available!"

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
    } else {
        Write-Host "Local module is up to date."
    }

    Remove-Item $tempFile -Force
} catch {
    Write-Warning "Failed to check remote version: ${$_}"
}

if (-not (Get-Module -Name BriteProvisioning)) {
    Import-Module $moduleName -Force
}