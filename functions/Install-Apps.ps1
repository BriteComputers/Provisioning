Function Install-Apps{
    
    Write-Host "Installing Apps"
    ##Install Adobe and Chrome for all sites
    Install-Adobe
    Install-Chrome
    Install-O365
    
    Switch ($SiteCode){
        "122" {
            Install-Teams
        }

        "312" {
            Install-Teams
            Install-Anyconnect
        }

        "114" {
            Install-Teams
        }

        "109" {
            Install-Teams
        }

        "287" {
            Install-Teams
            Install-7Zip
        }
        "374" {
            
        }
        "455"{
            Install-Bluebeam
            #Install-Citrix
            Install-AnyVideoConverter
            Install-ShareFile
            Install-ShareFilePlugin
            #VLC Install
            Install-VLC
            Install-DWGTrueview
            #Install-GoToResolve
            #Install-VSOImageResizer..... maybe
            #Install-eScreenz
            #Install-Navisworks
        }

        default {
            Write-Host "Site not set up in Global Functions"
        }
    }
}