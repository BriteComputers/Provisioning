Function Update-WindowTitle ([String] $PassNumber) {
    Write-Host "Changing window title"
    $host.ui.RawUI.WindowTitle = "Provisioning | $env:computername | Pass $PassNumber | Please Wait"
}

Function Set-RunOnce{

    param
    (
        [string]$Label
    )

    $RunOnceValue = 'PowerShell.exe -ExecutionPolicy Bypass -File "C:\IT\PPKG\' + $Label + '.ps1"'
    Write-Host "Install After Reboot"
    Set-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Name $Label -Value $RunOnceValue
    
}