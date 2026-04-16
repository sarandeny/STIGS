<#
.SYNOPSIS
    Configures Microsoft Account (MSA) optional sign-in setting.

.DESCRIPTION
    This script ensures the registry value 'MSAOptional' is set to 1
    under:

    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System

.NOTES
    Author          : Saran Deny
    LinkedIn        : https://www.linkedin.com/in/saran-deny/
    GitHub          : https://github.com/sarandeny
    Date Created    : 2026-04-16
    Last Modified   : 2026-04-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000170
    Documentation   : N/A

.TESTED ON
    Date(s) Tested  :
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 5.1 (Default on Windows 11)

.USAGE
    Run this script in an elevated PowerShell session.

    Example syntax:
    PS C:\> .\Set-MSAOptional.ps1
#>

# Ensure script is running as Administrator
$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# Registry configuration
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName    = "MSAOptional"
$valueType    = "DWord"
$valueData    = 1

try {
    # Create path if missing
    if (-not (Test-Path -Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Created registry path." -ForegroundColor Yellow
    }

    # Apply setting
    New-ItemProperty -Path $registryPath `
                     -Name $valueName `
                     -Value $valueData `
                     -PropertyType $valueType `
                     -Force | Out-Null

    Write-Host "Successfully set MSAOptional to 1." -ForegroundColor Green

    # Verification
    $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName
    Write-Host "Verified setting:" -ForegroundColor Cyan
    Write-Host "$valueName = $($currentValue.$valueName)" -ForegroundColor Cyan
}
catch {
    Write-Error "Failed to configure registry value. Error: $($_.Exception.Message)"
    exit 1
}
