function Enable-RemoteDesktop {
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' `
        -Name 'fDenyTSConnections' -Value 0

    Start-Service -Name 'TermService'
}