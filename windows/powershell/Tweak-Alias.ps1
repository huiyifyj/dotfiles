# git abbreviation
Set-Alias -Name g -Value git
Function Git-Status { git s $args }
Set-Alias -Name gs -Value Git-Status

# Alias is provider specific, so use Test-Path to check if the alias exists
# ref: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_alias_provider
# Remove built-in `curl` and `wget` aliases, they are aliases for `Invoke-WebRequest`
if (Test-Path Alias:curl) { Remove-Item Alias:curl }
if (Test-Path Alias:wget) { Remove-Item Alias:wget }

# Add aliases, .., ..., ...., ..... to move up directories by levels
Function Cd-Parent { Set-Location .. }
Set-Alias -Name .. -Value Cd-Parent
Function Cd-Parent-Twice { Set-Location ../.. }
Set-Alias -Name ... -Value Cd-Parent-Twice
Function Cd-Parent-Thrice { Set-Location ../../.. }
Set-Alias -Name .... -Value Cd-Parent-Thrice
Function Cd-Parent-Four { Set-Location ../../../.. }
Set-Alias -Name ..... -Value Cd-Parent-Four

# ~ to move to home directory
Function Cd-Home { Set-Location ~ }
Set-Alias -Name ~ -Value Cd-Home

# Set up ls-based aliases with `lsd`
if (Get-Command lsd -CommandType Application -ErrorAction SilentlyContinue) {
    Set-Alias -Name l -Value lsd -Option AllScope
    Function Lsd-Long { lsd -lh --date='+%Y-%m-%d %H:%M:%S' $args }
    Set-Alias -Name ll -Value Lsd-Long -Option AllScope
    Function Lsd-All { lsd -Alh --date='+%Y-%m-%d %H:%M:%S' $args }
    Set-Alias -Name la -Value Lsd-All -Option AllScope
    Function Lsd-Tree { lsd -A --tree --depth 2 --ignore-glob node_modules --ignore-glob .git $args }
    Set-Alias -Name lt -Value Lsd-Tree -Option AllScope
} else {
    Write-Warning "lsd command not found, skipping aliases l, ll, la and lt."
}

# Set up `wslc` aliases aligned with docker commands and abbreviation
if (Get-Command wslc -CommandType Application -ErrorAction SilentlyContinue) {
    Set-Alias -Name docker -Value wslc
    Set-Alias -Name d -Value wslc
    Function Docker-Compose { echo "wslc doesn't support compose currently" }
    Set-Alias -Name dc -Value Docker-Compose
} else {
    Write-Warning "wslc command not found, skipping aliases docker, d and dc."
    Write-Output "For more information about wslc, refer to:"
    Write-Host "https://blogs.windows.com/windowsdeveloper/2026/09/29/wsl-containers-now-generally-available/" -ForegroundColor Cyan
}

# Empty the trash (recycle bin)
Set-Alias -Name emptytrash -Value Clear-RecycleBin
