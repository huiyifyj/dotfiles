# The profile script for PowerShell.
# Copy this file to `$PROFILE` if it doesn't exist.

# Set the prompt to Starship
# ref: https://github.com/starship/starship
Invoke-Expression (&starship init powershell)

# git abbreviation
Set-Alias -Name g -Value git
Function Git-Status { git s $args }
Set-Alias -Name gs -Value Git-Status

# Use `curl`, not the `Invoke-WebRequest` alias
Remove-Item Alias:curl

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
