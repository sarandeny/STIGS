<#
.SYNOPSIS
    This PowerShell script configures the NTLM server minimum session security requirement.

.DESCRIPTION
    This script ensures the registry value 'NTLMMinServerSec' is set to
    0x20080000 (537395200) under:

    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0

.NOTES
    Author          : Saran Deny
    LinkedIn        : https://www.linkedin.com/in/saran-deny/
    GitHub          : https://github.com/sarandeny
    Date Created    : 2026-04-16
    Last Modified   : 2026-04-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : N/A
    Documentation   : N/A

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 5.1 (Default on Windows 11)

.USAGE
    Run this script in an elevated PowerShell session.

    Example syntax:
    PS C:\> .\Set-NTLMMinServerSec.ps1
#>

# Ensure script is running as Administrator
$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# Registry configuration
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$valueName    = "NTLMMinServerSec"
$valueType    = "DWord"
$valueData    = 537395200   # 0x20080000

try {
    # Create the registry path if it does not exist
    if (-not (Test-Path -Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Created registry path: $registryPath" -ForegroundColor Yellow
    }

    # Create or update the registry value
    New-ItemProperty -Path $registryPath `
                     -Name $valueName `
                     -Value $valueData `
                     -PropertyType $valueType `
                     -Force | Out-Null

    Write-Host "Successfully set $valueName to $valueData (0x20080000)." -ForegroundColor Green

    # Verification
    $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName
    Write-Host "Verified setting:" -ForegroundColor Cyan
    Write-Host "$valueName = $($currentValue.$valueName)" -ForegroundColor Cyan
}
catch {
    Write-Error "Failed to configure registry value. Error: $($_.Exception.Message)"
    exit 1
}
