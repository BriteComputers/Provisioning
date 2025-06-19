function Get-LatestCumulativeKB {
    <#
    .SYNOPSIS
        Gets the latest Cumulative Update KB for Windows 11 Pro 24H2.
    .REQUIRES
        PSWindowsUpdate module, Windows Update service running.
    #>

    # Ensure PSWindowsUpdate is loaded
    if (-not (Get-Command Get-WindowsUpdate -ErrorAction SilentlyContinue)) {
        Write-Warning "PSWindowsUpdate module not found. Run 'Install-Module PSWindowsUpdate' first."
        return
    }

    try {
        Write-Verbose "Querying Windows Update for available updates..."
        $updates = Get-WindowsUpdate -MicrosoftUpdate -IgnoreUserInput -AcceptAll -ErrorAction Stop

        $latestCU = $updates |
            Where-Object { $_.Title -like "*Cumulative Update*" -and $_.KBArticleIDs.Count -gt 0 } |
            Sort-Object -Property LastDeploymentChangeTime -Descending |
            Select-Object -First 1

        if ($latestCU) {
            $kb = $latestCU.KBArticleIDs[0]
            Write-Output $kb
        } else {
            Write-Warning "No cumulative updates found in update list."
        }
    } catch {
        Write-Warning "Failed to retrieve update information: $_"
    }
}

