Function Install-StoreApp{
    param (
    $PackageID,
    $Log
    )

    Start-Transcript -Path "$Global:BasePath\Logs\$Log"
    
    #Test if Winget is installed. If not, try and install it. 
    try {
        WinGet | Out-Null
    }
    catch {
        Install-WinGet
    }
    try {
        Winget | Out-Null
    }
    Catch {
        Write-Host "Winget not found after attempting to install. Stopping operation"
        exit 1
    }

    Winget install --id $PackageID --source msstore --silent --accept-package-agreements --accept-source-agreements 
    Stop-Transcript
}