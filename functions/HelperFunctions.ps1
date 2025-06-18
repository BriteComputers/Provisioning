Function Import-Config
 {
    param (
        [string]$Path = "$Global:BasePath\PPKG\config.json"
    )
    if (-Not (Test-Path $Path)) {
        throw "Config file not found at $Path"
    }
    return Get-Content $Path -Raw | ConvertFrom-Json
}
Function Set-ProtectionPolicy{

    Write-Host "Setting Protection Policy REG Key to Fix 365 app Login Errors"
    Set-ItemProperty 'HKLM:\Software\Microsoft\Cryptography\Protect\Providers\df9d8cd0-1501-11d1-8c7a-00c04fc297eb' -Name "ProtectionPolicy" -Value "1" -type DWord

}
Function Set-PCName{

    # Sample script to rename a domain joined computer
    $SerialNumber = (Get-WmiObject win32_bios).SerialNumber
    $NewComputerName = $SiteCode + "-" + $SerialNumber

    Write-Host "Rename Computer to" $NewComputerName
    Rename-Computer -NewName $NewComputerName

}
Function Disable-FastStartup {
    Write-Host "Disable Windows Fast Startup"
        REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d "0" /f
        powercfg -h off
}
Function Set-ESTTime{

Write-Host "Setting to Eastern Time Zones"

Set-TimeZone -Name "Eastern Standard Time"
net start W32Time
W32tm /resync /force

}
Function Set-NoSleep{

    Write-Host "Set Laptop not to sleep while plugged in"
    
    Powercfg /Change monitor-timeout-ac 0
    Powercfg /Change monitor-timeout-dc 10
    Powercfg /Change standby-timeout-ac 0
    Powercfg /Change standby-timeout-dc 30
    
}