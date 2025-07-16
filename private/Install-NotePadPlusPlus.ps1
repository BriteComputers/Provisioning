Function Install-NotePadPlusPlus{

    $InstallPath = "$Global:BasePath\Apps\NotepadPlusPlus"
    $DownloadFile = "$InstallPath\NotepadPlusPlus-Installer.exe"

    if (!(Test-Path $InstallPath)) {
        New-Item -ItemType "Directory" -Path $InstallPath
    }

    # Modern websites require TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    # Let's go directly to the website and see what it lists as the current version
    $BaseUri = "https://notepad-plus-plus.org"
    $BasePage = Invoke-WebRequest -Uri $BaseUri -UseBasicParsing
    $ChildPath = $BasePage.Links | Where-Object { $_.outerHTML -like '*Current Version*' } | Select-Object -ExpandProperty href
    # Now let's go to the latest version's page and find the installer
    $DownloadPageUri = $BaseUri + $ChildPath
    $DownloadPage = Invoke-WebRequest -Uri $DownloadPageUri -UseBasicParsing
    # Determine bit-ness of O/S and download accordingly
    if ( [System.Environment]::Is64BitOperatingSystem ) {
        $DownloadUrl = $DownloadPage.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.x64.exe"*' } | Select-Object -ExpandProperty href -Unique
    } else {
        $DownloadUrl = $DownloadPage.Links | Where-Object { $_.outerHTML -like '*npp.*.Installer.exe"*' } | Select-Object -ExpandProperty href -Unique
    }


    Write-Log "NotepadPlusPlus is not installed. Downloading latest version..."
    Write-Log "Download URL: $DownloadUrl"
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest $DownloadUrl -OutFile $DownloadFile
    Write-Log "Installing NotepadPlusPlus"
    Start-Process $DownloadFile -ArgumentList "/S" -wait
    
}