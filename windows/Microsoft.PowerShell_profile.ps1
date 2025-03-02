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

# ~ to move to home directory
Function Cd-Home { Set-Location ~ }
Set-Alias -Name ~ -Value Cd-Home

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
Function Get-Path() {
    # Machine Path
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    Write-Host "Machine Path:" -ForegroundColor Red
    $machinePath -split ";" | ForEach-Object {
        if (-Not [string]::IsNullOrWhiteSpace($_)) {
            Write-Output $_
        }
    }
    # User Path
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    Write-Host "User Path:" -ForegroundColor Green
    $userPath -split ";" | ForEach-Object {
        if (-Not [string]::IsNullOrWhiteSpace($_)) {
            Write-Output $_
        }
    }
}
Set-Alias -Name path -Value Get-Path

# Add `debase64` and `base64` aliases to decode and encode strings
# Decode-Base64 and Encode-Base64 functions
Function Decode-Base64() {
    if (-Not ($args.Count -eq 1)) {
        Write-Host "Argument must be a single string"
        return
    }
    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($args))
}
Set-Alias -Name debase64 -Value Decode-Base64
Function Encode-Base64() {
    if (-Not ($args.Count -eq 1)) {
        Write-Host "Argument must be a single string"
        return
    }
    [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($args))
}
Set-Alias -Name base64 -Value Encode-Base64

# Update rust toolchain and rustup itself
Function Update-Rust() {
    $useMirror = $true
    # Check if specific network adapter is up
    Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | ForEach-Object {
        # TUN/TAP adapter for clash meta mihomo
        if ($_.Name -Like '*ihomo*' -or $_.InterfaceDescription -Like '*eta*') {
            Write-Host "Found TUN/TAP adapter: $($_.Name) - $($_.InterfaceDescription)" -ForegroundColor Green
            Write-Host "Skip setting proxy-related environment variables" -ForegroundColor Green
            $useMirror = $false
            return
        }
    }
    # Check if HTTP_PROXY, HTTPS_PROXY, ALL_PROXY environment variables are set
    if ($useMirror -and ($env:HTTP_PROXY -or $env:HTTPS_PROXY -or $env:ALL_PROXY)) {
        Write-Host "HTTP_PROXY, HTTPS_PROXY, ALL_PROXY environment variables are set" -ForegroundColor Yellow
        Write-Host "Skip setting rust and rustup mirror environment variables" -ForegroundColor Yellow
        $useMirror = $false
    }
    # Set rust and rustup mirror environment variables
    if ($useMirror) {
        Write-Host "Set rust and rustup mirror environment variables" -ForegroundColor Green
        # refer to https://mirrors.ustc.edu.cn/help/rust-static.html
        $env:RUSTUP_DIST_SERVER="https://mirrors.ustc.edu.cn/rust-static"
        $env:RUSTUP_UPDATE_ROOT="https://mirrors.ustc.edu.cn/rust-static/rustup"
    }
    # Update rustup and rust toolchain
    rustup self update
    rustup update
}
Set-Alias -Name update_rust -Value Update-Rust
