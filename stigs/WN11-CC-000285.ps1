<#
.SYNOPSIS
    This PowerShell script ensures that RPC traffic for Remote Desktop Protocol (RDP) is encrypted
    by setting the 'fEncryptRPCTraffic' registry value to 1.

.NOTES
    Author          : Saran Deny
    LinkedIn        : linkedin.com/in/saran-deny
    GitHub          : github.com/sarandeny
    Date Created    : 2026-04-13
    Last Modified   : 2026-04-13
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000300
    Documentation   : https://stigaview.com/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  :
    PowerShell Ver. : 

.USAGE
    Run this script with administrative privileges.

    Example:
    PS C:\> .\Encrypt-RPC-RDP.ps1
#>

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$valueName = "fEncryptRPCTraffic"
$desiredValue = 1

Write-Host "[INFO] Checking registry path..." -ForegroundColor Cyan

# Ensure registry path exists
if (-not (Test-Path $regPath)) {
    Write-Host "[INFO] Registry path not found. Creating..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Write-Host "[INFO] Setting registry value..." -ForegroundColor Cyan

# Set the registry value
New-ItemProperty -Path $regPath `
    -Name $valueName `
    -PropertyType DWord `
    -Value $desiredValue `
    -Force | Out-Null

# Verify the change
$currentValue = (Get-ItemProperty -Path $regPath -Name $valueName).$valueName

if ($currentValue -eq $desiredValue) {
    Write-Host "[SUCCESS] fEncryptRPCTraffic is correctly set to 1 (Enabled)." -ForegroundColor Green
} else {
    Write-Host "[ERROR] Failed to set fEncryptRPCTraffic." -ForegroundColor Red
}
