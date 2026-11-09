# Functions to start and stop the related service, such as mihomo.
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
