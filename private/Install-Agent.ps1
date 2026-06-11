function Install-Agent {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory=$True)]
        [string]$Token,

        [Parameter(Mandatory=$True)]
        [string]$Domain,

        [Parameter(Mandatory=$false)]
        [string]$BasePath = "C:\ProgramData\Deployment",

        [Parameter(Mandatory=$false)]
        [string]$SiteCode = "274"
    );

    Write-Log "Starting agent installation for domain: $Domain with site code: $SiteCode" -Type "INFO"
    $TempPath = "$BasePath\Apps\Agent"
    $DownloadPath = "$TempPath\WindowsAgentSetup.exe"
    $AgentDownload = "https://rmm.$Domain/download/2026.2.0.15/winnt/N-central/WindowsAgentSetup.exe"

    Write-Log "Ensuring temporary directory exists at: $TempPath" -Type "INFO"
    if (!(Test-Path $TempPath)) {
        New-Item -ItemType "Directory" -Path $TempPath
    }
    
    $progressPreference = 'silentlyContinue'
    Write-log "downloading agent from: $AgentDownload" -Type "INFO"
    Invoke-Webrequest $AgentDownload -OutFile $DownloadPath
    
    Write-Log "Starting agent installation process" -Type "INFO"
    Start-Process $DownloadPath -ArgumentList "/s /v"" /qn CUSTOMERID=$SiteCode REGISTRATION_TOKEN=$Token CUSTOMERSPECIFIC=1 SERVERPROTOCOL=HTTPS SERVERADDRESS=rmm.$Domain SERVERPORT=443""" -wait

    Write-Log "Agent installation process completed" -Type "INFO"
}