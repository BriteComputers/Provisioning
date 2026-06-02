function Install-Agent {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory=$True)]
        [string]$Token,

        [Parameter(Mandatory=$True)]
        [string]$Domain,

        [Parameter(Mandatory=$false)]
        [string]$Global:BasePath = "C:\ProgramData\Deployment",

        [Parameter(Mandatory=$false)]
        [string]$Global:SiteCode = "274"
    );

    Write-Host "Installing N-able N-central Agent..." -ForegroundColor Cyan;
    Write-Host "This may take a few minutes, please wait..." -ForegroundColor Yellow;
    write-Host "Customer ID: $SiteCode" -ForegroundColor Green;
    write-Host "Customer ID: $Global:SiteCode" -ForegroundColor Green;
    write-Host "Domain: $Domain" -ForegroundColor Green;
    write-Host "Token: $Token" -ForegroundColor Green;
    write-Host "Base Path: $BasePath" -ForegroundColor Green;
    write-Host "Base Path: $Global:BasePath" -ForegroundColor Green;

    $TempPath = "$Global:BasePath\Apps\Agent"
    Write-Host "Temp Path: $TempPath" -ForegroundColor Green;
    $DownloadPath = "$TempPath\WindowsAgentSetup.exe"
    write-Host "Download Path: $DownloadPath" -ForegroundColor Green;
    $AgentDownload = "https://rmm.$Domain/download/2026.2.0.15/winnt/N-central/WindowsAgentSetup.exe"
    Write-Host "Agent Download URL: $AgentDownload" -ForegroundColor Green;

    if (!(Test-Path $TempPath)) {
        New-Item -ItemType "Directory" -Path $TempPath
    }
    
    $progressPreference = 'silentlyContinue'
    write-Host "Downloading Agent..." -ForegroundColor Cyan;
    Invoke-Webrequest $AgentDownload -OutFile $DownloadPath
    write-Host "Download completed." -ForegroundColor Green;
    
    write-Host "Starting Agent installation..." -ForegroundColor Cyan;
    write-Host "This may take a few minutes, please wait..." -ForegroundColor Yellow;
    write-Host "Executing: $DownloadPath /s /v"" /qn CUSTOMERID=$Global:SiteCode REGISTRATION_TOKEN=$Token CUSTOMERSPECIFIC=1 SERVERPROTOCOL=HTTPS SERVERADDRESS=rmm.$Domain SERVERPORT=443""" -ForegroundColor Green;

    Start-Process $DownloadPath -ArgumentList "/s /v"" /qn CUSTOMERID=$Global:SiteCode REGISTRATION_TOKEN=$Token CUSTOMERSPECIFIC=1 SERVERPROTOCOL=HTTPS SERVERADDRESS=rmm.$Domain SERVERPORT=443""" -wait

    Write-Host "Agent installation completed." -ForegroundColor Green;
}