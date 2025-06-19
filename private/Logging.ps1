function Write-Log {
    param (
        [string]$Message,
        [string]$Type = "INFO",
        [string]$LogName = "Deployment"
    )

    if (-not $script:LogDirectoryInitialized) {
        $script:LogRoot = "$Global:BasePath\Logs"
        if (-not (Test-Path $script:LogRoot)) {
            New-Item -Path $script:LogRoot -ItemType Directory -Force | Out-Null
        }
        $script:LogDirectoryInitialized = $true
    }

    $LogPath = "$script:LogRoot\$LogName.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Type]  $Message"
    Write-Output $logEntry | Out-File -FilePath $LogPath -Append -Encoding UTF8
}
Function Start-PPKGLog ([String] $LogLabel) {
    Write-Host "Making a log file for debugging"
        $LogPath = $Global:BasePath + "\PPKG\" + $LogLabel + ".log"
        Start-Transcript -path $LogPath -Force -Append
}