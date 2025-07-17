Function Install-WinSCP{

    #Install-StoreApp -PackageID "WinSCP.WinSCP" -Log "WinSCPWingetInstall.log"

    Winget install --id WinSCP.WinSCP --silent --accept-source-agreements --accept-package-agreements
    
}