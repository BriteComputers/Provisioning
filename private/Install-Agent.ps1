function Install-Agent {

    [CmdletBinding()]
    param(
        # Latest stable version of NefCon installer
        [Parameter(Mandatory=$True)]
        [string]$Token,

        [Parameter(Mandatory=$True)]
        [string]$Domain,
        # Latest stable version of VDD driver only
        [Parameter(Mandatory=$false)]
        [string]$BasePath = "C:\ProgramData\Deployment",

        [Parameter(Mandatory=$false)]
        [string]$SiteCode = "274"
    );
    
    $TempPath = "$Global:BasePath\Apps\Agent"
    $DownloadPath = "$TempPath\WindowsAgentSetup.exe"
    $AgentDownload = "https://rmm.$Domain/download/2026.2.0.15/winnt/N-central/WindowsAgentSetup.exe"

    if (!(Test-Path $TempPath)) {
        New-Item -ItemType "Directory" -Path $TempPath
    }
    
    $progressPreference = 'silentlyContinue'
    Invoke-Webrequest $AgentDownload -OutFile $DownloadPath
    
    Start-Process $DownloadPath -ArgumentList "/s /v"" /qn CUSTOMERID=$Global:SiteCode REGISTRATION_TOKEN=$Token CUSTOMERSPECIFIC=1 SERVERPROTOCOL=HTTPS SERVERADDRESS=rmm.$Domain SERVERPORT=443""" -wait

}