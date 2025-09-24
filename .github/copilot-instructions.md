# Copilot Instructions for ManagementScripts Repository

## Overview
This repository contains PowerShell scripts and modules for Windows provisioning, configuration, and automation across multiple customers and environments. The codebase is organized by function, customer, and deployment scenario. Most scripts are designed to be modular, reusable, and parameter-driven.

## Architecture & Structure
- **Provisioning Module**: Located in `Provisioning/`, this is a PowerShell module (`BriteProvisioning.psm1`, `.psd1`) that imports all scripts from `functions/` and `private/`.
- **Functions**: Core provisioning logic is in `Provisioning/functions/`. Each script implements a specific task (e.g., `Install-Apps.ps1`, `Update-Windows.ps1`, `Convert-AESPasswordToDPAPI.ps1`).
- **Customer-Specific Scripts**: Located in `Powershell/Customer Specific/` and similar folders, these scripts handle unique requirements for individual clients.
- **App Deployments**: `AppDeployments/` and `DeviceManagement/Apps/` contain per-app install scripts and documentation.

## Key Patterns & Conventions
- **Logging**: Use a `Write-Log` function for consistent logging. Log files are typically stored in `C:\ProgramData\Deployment\Logs`. Example:
  ```powershell
  Write-Log "Starting Update-Windows function."
  ```
- **Parameterization**: Functions accept parameters for site codes, credentials, and configuration paths. Use `[Parameter(Mandatory = $true)]` for required inputs.
- **Modular Imports**: The module auto-imports all scripts in `functions/` and `private/` using `$PSScriptRoot`.
- **Error Handling**: Scripts use try/catch blocks and log errors with `Write-Log ... -Type "ERROR"`.
- **Registry Edits**: Many scripts modify registry keys for configuration (e.g., autologon, protection policy, screensaver settings).
- **App Install/Uninstall**: App scripts use `Start-Process` for installers and check for prerequisites (e.g., directory existence, module availability).
- **Update Management**: `Update-Windows.ps1` uses the `PSWindowsUpdate` module and can hide cumulative updates based on parameters.

## Developer Workflows
- **Module Usage**: Import the module with `Import-Module ./Provisioning/BriteProvisioning.psm1`.
- **Function Execution**: Call functions directly (e.g., `Install-Apps -SiteCode 455`).
- **Testing**: No formal test framework; validate scripts by running in PowerShell 5.1+.
- **Debugging**: Use verbose logging and inspect log files in `C:\ProgramData\Deployment\Logs`.

## Integration Points
- **External Modules**: Scripts may install/import modules like `PSWindowsUpdate` and `TimeZoneConverter`.
- **Network/Remote**: Some scripts connect to VPNs, download installers, or interact with remote APIs.
- **Registry & System**: Scripts frequently interact with Windows registry and system services.

## Examples
- **Install Apps for a Site**:
  ```powershell
  Install-Apps -SiteCode 455
  ```
- **Update Windows and Hide Cumulative Updates**:
  ```powershell
  Update-Windows -HideCumulativeUpdates Yes
  ```
- **Convert AES Password to DPAPI**:
  ```powershell
  Convert-AESPasswordToDPAPI -ConfigPath "C:\Path\config.json" -KeyPath "C:\Path\key.bin"
  ```

## References
- See `Provisioning/functions/` for reusable functions.
- See customer-specific folders for tailored scripts.
- App install scripts are in `AppDeployments/Apps/` and `DeviceManagement/Apps/`.

---

**Feedback Requested:**
Please review and suggest improvements or clarify any missing or ambiguous sections. This document is intended to help AI agents work productively in this repository.
