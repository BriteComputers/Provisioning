@{
    RootModule        = 'BriteProvisioning.psm1'
    ModuleVersion     = '0.1.0'
    Author            = 'You'
    Description       = 'PowerShell module for provisioning and configuration tasks'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('*')  # Or explicitly list exported functions
    PrivateData       = @{
        PSData = @{
            Tags = @('provisioning', 'automation', 'windows')
        }
    }
}
