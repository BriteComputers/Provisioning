Function Connect-Wifi {
    param
        (
            [Parameter(Mandatory=$False)]
            [string]$NetworkSSID,

            [Parameter(Mandatory=$true)]
            [string]$NetworkPassword,

            [ValidateSet('WEP','WPA','WPA2','WPA2PSK')]
            [Parameter(Mandatory=$False)]
            [string]$Authentication = 'WPA2PSK',

            [ValidateSet('AES','TKIP')]
            [Parameter(Mandatory=$False)]
            [string]$Encryption = 'AES'
        )

    # Create the WiFi profile, set the profile to auto connect
    $WirelessProfile = @'
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>{0}</name>
    <SSIDConfig>
        <SSID>
            <name>{0}</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>{2}</authentication>
                <encryption>{3}</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>{1}</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>
'@ -f $NetworkSSID, $NetworkPassword, $Authentication, $Encryption
        
    
    # Create the XML file locally
    $random = Get-Random -Minimum 1111 -Maximum 99999999
    $tempProfileXML = "$env:TEMP\tempProfile$random.xml"
    $WirelessProfile | Out-File $tempProfileXML

    # Add the WiFi profile and connect
    Start-Process netsh ('wlan add profile filename={0}' -f $tempProfileXML)

    # Connect to the WiFi network - only if you need to
    $WifiNetworks = (netsh wlan show network)
    $NetworkSSIDSearch = '*' + $NetworkSSID + '*'
    If ($WifiNetworks -like $NetworkSSIDSearch) {
        Write-Host "Found SSID: $NetworkSSID `nAttempting to connect"
        Start-Process netsh ('wlan connect name="{0}"' -f $NetworkSSID)
        Start-Sleep 5
        netsh interface show interface
    } Else {
        Write-Host "Did not find SSID: $NetworkSSID `nConnection profile stored for later use."
    }
}
