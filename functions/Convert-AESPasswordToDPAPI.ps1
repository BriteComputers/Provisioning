function Convert-AESPasswordToDPAPI {
    param (
        [string]$ConfigPath = "$Global:BasePath\PPKG\config.json",
        [string]$KeyPath = "$Global:BasePath\PPKG\key.bin"
    )

        Write-Log "Starting Convert-AESPasswordToDPAPI function."

    if (-not (Test-Path $ConfigPath)) {
        Write-Log "Config file not found at $ConfigPath" -Type "ERROR"
        Write-Error "Config file not found at $ConfigPath"
        return
    }

    if (-not (Test-Path $KeyPath)) {
        Write-Log "AES key file not found at $KeyPath" -Type "ERROR"
        Write-Error "AES key file not found at $KeyPath"
        return
    }

    try {
        Write-Log "Loading config from $ConfigPath."
        # Load config
        $Config = Get-Content $ConfigPath | ConvertFrom-Json

        Write-Log "Loading AES key from $KeyPath."
        # Load AES key
        $Key = [IO.File]::ReadAllBytes($KeyPath)

        Write-Log "Decrypting password using AES key."
        # Decrypt password from AES to SecureString
        $SecurePassword = $Config.Password | ConvertTo-SecureString -Key $Key

        Write-Log "Re-encrypting password using DPAPI."
        # Re-encrypt using DPAPI (current user context)
        $DPAPIEncrypted = $SecurePassword | ConvertFrom-SecureString

        # Replace in config and save
        $Config.Password = $DPAPIEncrypted
        $Config | ConvertTo-Json -Depth 3 | Set-Content $ConfigPath
        Write-Log "Password replaced in config and saved to $ConfigPath."

        # Delete key file
        Remove-Item $KeyPath -Force
        Write-Log "Deleted AES key file at $KeyPath."

        Write-Log "Password decrypted using AES and re-saved with DPAPI. key.bin removed."
        Write-Host "🔐 Password decrypted using AES and re-saved with DPAPI. key.bin removed."
    }
    catch {
        Write-Log "Error during conversion: $_" -Type "ERROR"
        Write-Error "Error during conversion: $_"
    }
}