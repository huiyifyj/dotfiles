# The profile script for PowerShell.
# Copy this file to `$PROFILE` if it doesn't exist.
# Use the following command to find the location of `$PROFILE`:
# ```
# $PROFILE | Select-Object *
# ```
# ref: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.5#the-profile-variable

# Set the prompt to Starship
# ref: https://github.com/starship/starship
Invoke-Expression (&starship init powershell)

# git abbreviation
Set-Alias -Name g -Value git
Function Git-Status { git s $args }
Set-Alias -Name gs -Value Git-Status

# Alias is provider specific, so use Test-Path to check if the alias exists
# ref: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_alias_provider
# Remove built-in `curl` and `wget` aliases, they are aliases for `Invoke-WebRequest`
if (Test-Path Alias:curl) { Remove-Item Alias:curl }
if (Test-Path Alias:wget) { Remove-Item Alias:wget }

if (-Not ($PSVersionTable.PSEdition -eq 'Core')) {
    # Remind switching to PowerShell Core (pwsh) in terminal
    # Just a reminder, not enforced
    Write-Host "Please use pwsh in terminal" -BackgroundColor Yellow -ForegroundColor Red
}

# Add aliases, .., ..., ...., ..... to move up directories by levels
Function Cd-Parent { Set-Location .. }
Set-Alias -Name .. -Value Cd-Parent
Function Cd-Parent-Twice { Set-Location ../.. }
Set-Alias -Name ... -Value Cd-Parent-Twice
Function Cd-Parent-Thrice { Set-Location ../../.. }
Set-Alias -Name .... -Value Cd-Parent-Thrice
Function Cd-Parent-Four { Set-Location ../../../.. }
Set-Alias -Name ..... -Value Cd-Parent-Four

# Override ls with `lsd`
Set-Alias -Name ls -Value lsd -Option AllScope
Function Lsd-Long { lsd -lh --date='+%Y-%m-%d %H:%M:%S' $args }
Set-Alias -Name ll -Value Lsd-Long -Option AllScope
Function Lsd-All { lsd -Alh --date='+%Y-%m-%d %H:%M:%S' $args }
Set-Alias -Name la -Value Lsd-All -Option AllScope
Function Lsd-Tree { lsd -A --tree --depth 2 --ignore-glob node_modules --ignore-glob .git $args }
Set-Alias -Name lt -Value Lsd-Tree -Option AllScope

# docker abbreviation
Set-Alias -Name d -Value docker
Function Docker-Compose { echo $args }
Set-Alias -Name dc -Value Docker-Compose

# Print each PATH entry on a separate line
Function Split-Path {
    $env:PATH.split(';') | ForEach-Object {
        Write-Output $_
    }
}
Set-Alias -Name path -Value Split-Path

# Update rust toolchain and rustup itself
Function Update-Rust() {
    rustup self update
    rustup update
}
Set-Alias -Name update_rust -Value Update-Rust
