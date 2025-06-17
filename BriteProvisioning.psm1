# Import functions from 'functions' folder
Get-ChildItem -Path "$PSScriptRoot\functions\*.ps1" | ForEach-Object {
    . $_.FullName
}

# Import private/internal-use scripts
if (Test-Path "$PSScriptRoot\private") {
    Get-ChildItem -Path "$PSScriptRoot\private\*.ps1" | ForEach-Object {
        . $_.FullName
    }
}
