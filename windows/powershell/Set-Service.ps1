# Functions to start and stop the related service, including Mihomo and Tailscale.
# This script provides functions to manage services using Scoop-installed executables.

# Define the root path for Scoop and check if it exists.
# Only support Scoop installed at the default location for now, i.e., $env:USERPROFILE\scoop
$SCOOP_ROOT = "$env:USERPROFILE\scoop"
if (-Not (Test-Path $SCOOP_ROOT)) {
    Write-Warning "Scoop is not installed at $SCOOP_ROOT"
    Write-Warning "or you install Scoop at the specified location."
    Exit
}

Function Mihomo-Start() {
    Write-Host "⏹️ Checking mihomo process whether it is running..." -ForegroundColor Gray -NoNewline
    $mihomoProcess = Get-Process -Name mihomo -ErrorAction SilentlyContinue
    if ($mihomoProcess) {
        Write-Host "`r⚠️ mihomo process is already running" -ForegroundColor Yellow
        $mihomoProcess | Format-Table # print mihomo process details
        return
    }

    # Define the path to the mihomo executable.
    $binPATH = "$SCOOP_ROOT\apps\mihomo\current\mihomo.exe"

    # Ensure the mihomo executable exists before attempting to start it.
    if (-Not (Test-Path $binPATH)) {
        Write-Host "`r❌ mihomo executable not found at $binPATH" -ForegroundColor Red
        return
    }

    Write-Host "`r⏳ Starting mihomo service..." -ForegroundColor Gray -NoNewline
    sudo $env:SHELL -command "Start-Process $binPATH -WindowStyle Hidden"
    Write-Host "`r✅ mihomo service started successfully" -ForegroundColor Green
}

Function Mihomo-Stop() {
    Write-Host "⏹️ Checking mihomo process whether it is running..." -ForegroundColor Gray -NoNewline
    $mihomoProcess = Get-Process -Name mihomo -ErrorAction SilentlyContinue
    if (-Not $mihomoProcess) {
        Write-Host "`r⚠️ mihomo process is not running" -ForegroundColor Yellow
        return
    }

    Write-Host "`r⏳ Stopping mihomo service..." -ForegroundColor Gray -NoNewline
    sudo $env:SHELL -command "Stop-Process -Name mihomo"
    Write-Host "`r✅ mihomo service stopped successfully" -ForegroundColor Green
}

Function Tailscale-Start() {
    Write-Host "⏹️ Checking tailscale whether installed..." -ForegroundColor Gray -NoNewline
    if (-Not (Get-Command tailscale -ErrorAction SilentlyContinue)) {
        Write-Host "`r⚠️ Tailscale is not installed" -ForegroundColor Yellow
        return
    }

    Write-Host "`r⏳ Checking tailscaled daemon process whether it is running..." -ForegroundColor Gray -NoNewline
    $tailscaledProcess = Get-Process -Name tailscaled -ErrorAction SilentlyContinue
    Write-Host "`r⏳ Checking tailscale-ipn GUI process whether it is running..." -ForegroundColor Gray -NoNewline
    $tailscaleIpnProcess = Get-Process -Name tailscale-ipn -ErrorAction SilentlyContinue
    if ($tailscaledProcess -And $tailscaleIpnProcess) {
        Write-Host "`r⚠️ Tailscale service is already running" -ForegroundColor Yellow
        return
    }

    Write-Host "`r⏳ Starting Tailscale service..." -ForegroundColor Gray -NoNewline

    if (-Not $tailscaledProcess) {
        Write-Host "`r⏳ Starting tailscaled daemon service..." -ForegroundColor Gray -NoNewline
        sudo $env:SHELL -command "Start-Process $SCOOP_ROOT\apps\tailscale\current\tailscaled.exe -WindowStyle Hidden"

        Start-Sleep -Seconds 1 # Wait for tailscaled daemon to start completely
    }
    if (-Not $tailscaleIpnProcess) {
        Write-Host "`r⏳ Starting tailscale-ipn GUI service..." -ForegroundColor Gray -NoNewline
        # pwsh start it will output logs in the terminal, and its lifecycle will be tied to the terminal session,
        # using explorer to start it will detach it from the terminal session.
        # https://learn.microsoft.com/zh-cn/windows/win32/shell/developing-with-windows-explorer
        explorer $SCOOP_ROOT\apps\tailscale\current\tailscale-ipn.exe
    }

    Write-Host "`r✅ Tailscale service started successfully" -ForegroundColor Green
}

Function Tailscale-Stop() {
    $needToStopTailscale = $true
    $needToStopTailscaleIpn = $true

    Write-Host "`r⏳ Checking tailscaled daemon process whether it is running..." -ForegroundColor Gray -NoNewline
    $tailscaledProcess = Get-Process -Name tailscaled -ErrorAction SilentlyContinue
    if (-Not $tailscaledProcess) {
        Write-Host "`r⚠️ Tailscale daemon process is not running" -ForegroundColor Yellow
        $needToStopTailscale = $false
    }

    Write-Host "`r⏳ Checking tailscale-ipn GUI whether it is running..." -ForegroundColor Gray -NoNewline
    $tailscaleIpnProcess = Get-Process -Name tailscale-ipn -ErrorAction SilentlyContinue
    if (-Not $tailscaleIpnProcess) {
        Write-Host "`r⚠️ Tailscale GUI process is not running" -ForegroundColor Yellow
        $needToStopTailscaleIpn = $false
    }

    if (-Not $needToStopTailscale -And -Not $needToStopTailscaleIpn) {
        Write-Host "`r⚠️ No Tailscale processes need to be stopped" -ForegroundColor Yellow
        return
    }

    Write-Host "`r⏳ Stopping Tailscale service..." -ForegroundColor Gray -NoNewline

    if ($needToStopTailscaleIpn) {
        Write-Host "`r⏳ Stopping tailscale-ipn GUI process..." -ForegroundColor Gray -NoNewline
        & $env:SHELL -command "Stop-Process -Name tailscale-ipn"

        Start-Sleep -Seconds 1 # Wait for Tailscale GUI process to stop
    }
    if ($needToStopTailscale) {
        Write-Host "`r⏳ Stopping tailscaled daemon process..." -ForegroundColor Gray -NoNewline
        sudo $env:SHELL -command "Stop-Process -Name tailscaled"
    }

    Write-Host "`r✅ Tailscale service stopped successfully" -ForegroundColor Green
}
