# Disable Smart App Control
function Disable-SmartAppControl {

    New-ItemProperty `
        -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy' `
        -Name 'VerifiedAndReputablePolicyState' `
        -PropertyType DWord `
        -Value 0 `
        -Force `
        -ErrorAction Continue | Out-Null

    # Apply the change
    & "$env:windir\System32\CiTool.exe" -r -json

}