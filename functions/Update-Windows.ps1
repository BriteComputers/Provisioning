function Update-Windows {
    param (
        [ValidateSet('Yes','No')]
        [string]$HideCumulativeUpdates = "No"
    )

    Write-Log "Starting Update-Windows function."

    Get-PackageProvider -Name "NuGet" -ForceBootstrap | Out-Null
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Log "PSWindowsUpdate module not found. Installing..."
        Install-Module PSWindowsUpdate -Force
        Write-Log "PSWindowsUpdate module installed."
    }
    Import-Module PSWindowsUpdate -Force
    Write-Log "PSWindowsUpdate module imported."

    # Ensure update service and Microsoft Update source are ready
    try {
        Set-Service -Name wuauserv -StartupType Manual -ErrorAction SilentlyContinue
        Start-Service -Name wuauserv -ErrorAction SilentlyContinue

        if (-not (Get-WUServiceManager | Where-Object ServiceID -eq "7971f918-a847-4430-9279-4a52d1efe18d")) {
            Add-WUServiceManager -MicrosoftUpdate -Confirm:$false | Out-Null
            Write-Log "Registered Microsoft Update service source."
        }
    } catch {
        Write-Log "Could not initialize Windows Update service or source: $_" -Type "ERROR"
    }

    Write-Log $HideCumulativeUpdates

    $progressPreference = 'SilentlyContinue'

    # Get available updates
    try {
        Write-Log "Retrieving available updates..."
        $availableUpdates = Get-WindowsUpdate -Verbose
        Write-Log "Retrieved $($availableUpdates.Count) updates."
    } catch {
        Write-Log "Failed to retrieve available updates: $_" -Type "ERROR"
        return
    }

    if ($HideCumulativeUpdates -eq "Yes") {
        foreach ($update in $availableUpdates) {
            Write-Log "Checking of $($Update.Title) Contains the words Cumulative Update"
            if ($update.Title -like "*2025-*Cumulative Update*for Windows 11 Version 24H2*") {
                $kb = ($update.KBArticleIDs)[0]
                try {
                    Hide-WindowsUpdate -KBArticleID $kb -AcceptAll
                    Write-Log "Hid cumulative update: $($update.Title) (KB$kb)"
                } catch {
                    Write-Log "Failed to hide $($kb): $_" -Type "ERROR"
                }
            }
        }

        # Refresh update list after hiding
        $availableUpdates = Get-WindowsUpdate -AcceptAll -IgnoreUserInput -MicrosoftUpdate
        Write-Log "Refreshed update list after hiding cumulative updates."
    }

    # Format and log update info before install
    $formattedUpdates = $availableUpdates | Format-Table `
        @{Label="Status"; Expression={$_.Status}}, `
        @{Label="KB"; Expression={ ($_.KBArticleIDs -join ",") }}, `
        @{Label="SizeMB"; Expression={ "{0:N0}" -f ($_.MaxDownloadSize / 1MB) }}, `
        @{Label="Title"; Expression={$_.Title}} -AutoSize | Out-String

    $updateListLog = "$Global:BasePath\Logs\Updates_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').Log"
    $formattedUpdates | Set-Content -Path $updateListLog
    Write-Log "Available updates logged to $updateListLog"

    # Install updates
    try {
        Write-Log "Installing updates..."
        $availableUpdates | Install-WindowsUpdate -AcceptAll -IgnoreReboot -Verbose
        Write-Log "Update installation completed."
    } catch {
        Write-Log "Update installation failed: $_" -Type "ERROR"
    }

    Write-Log "Windows Update process complete."
}