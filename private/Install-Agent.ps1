function Install-Agent {
    Param(
        $Token,
        $Domain
    )
    $TempPath = "$Global:BasePath\Apps\Agent"
    $DownloadPath = "$TempPath\WindowsAgentSetup.exe"
    $AgentDownload = "https://rmm.$Domain/download/2025.4.1.2/winnt/N-central/WindowsAgentSetup.exe"

    if (!(Test-Path $TempPath)) {
        New-Item -ItemType "Directory" -Path $TempPath
    }
    
    $progressPreference = 'silentlyContinue'
    Invoke-Webrequest $AgentDownload -OutFile $DownloadPath
    
    Start-Process $DownloadPath -ArgumentList "/s /v"" /qn CUSTOMERID=$Global:SiteCode REGISTRATION_TOKEN=$Token CUSTOMERSPECIFIC=1 SERVERPROTOCOL=HTTPS SERVERADDRESS=rmm.$Domain SERVERPORT=443""" -wait

}