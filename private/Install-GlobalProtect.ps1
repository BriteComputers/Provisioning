Function Install-GlobalProtect{
    param (
        $Portal
    )

    $argsString = ""
    If ($ENV:PROCESSOR_ARCHITEW6432 -eq "AMD64")
    {
        Try
        {
            foreach ($k in $MyInvocation.BoundParameters.keys)
            {
                switch ($MyInvocation.BoundParameters[$k].GetType().Name)
                {
                    "SwitchParameter" { if ($MyInvocation.BoundParameters[$k].IsPresent) { $argsString += "-$k " } }
                    "String"          { $argsString += "-$k `"$($MyInvocation.BoundParameters[$k])`" " }
                    "Int32"           { $argsString += "-$k $($MyInvocation.BoundParameters[$k]) " }
                    "Boolean"         { $argsString += "-$k `$$($MyInvocation.BoundParameters[$k]) " }
                }
            }
            Start-Process -FilePath "$ENV:WINDIR\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -ArgumentList "-File `"$($PSScriptRoot)\Install-GlobalProtect.ps1`" $($argsString)" -Wait -NoNewWindow
        }
        Catch
        {
            Throw "Failed to start 64-bit PowerShell"
        }
        Exit
    }

    $LogPath = "$Global:BasePath\Logs\GlobalProtectInstall.log"

    Start-Transcript -path $LogPath -Force -Append

    $DowloadURL = "https://$Portal/global-protect/msi/GlobalProtect64.msi"
    $TempPath = "C:\IT\Apps\GlobalProtect"
    $DownloadFile = "$TempPath\GlobalProtect-Installer.msi"

    if (!(Test-Path $TempPath)) {
        New-Item -ItemType "Directory" -Path $TempPath
    }

    Write-Host "GlobalProtect is not installed. Downloading latest version..."
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest $DowloadURL -OutFile $DownloadFile
    Write-Host "Installing GlobalProtect"
    Start-Process msiexec.exe -ArgumentList "/i $DownloadFile  /qn /norestart PORTAL=$Portal" -wait

    #CANCONTINUEIFPORTALCERTINVALID=”yes”

    Stop-transcript
}