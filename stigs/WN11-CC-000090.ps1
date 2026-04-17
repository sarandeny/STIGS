<#
.SYNOPSIS
    Prevents unauthorized changes to Group Policy Object (GPO) list behavior.

.DESCRIPTION
    This script ensures the registry value 'NoGPOListChanges' is set to 0
    under:

    HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}

.NOTES
    Author          : Saran Deny
    LinkedIn        : https://www.linkedin.com/in/saran-deny/
    GitHub          : https://github.com/sarandeny
    Date Created    : 2026-04-17
    Last Modified   : 2026-04-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : N/A
    Documentation   : N/A

.TESTED ON
    Date(s) Tested  : 2026-04-17
    Tested By       : Saran Deny
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1 (Default on Windows 11)

.USAGE
    Run this script in an elevated PowerShell session.

    Example syntax:
    PS C:\> .\Set-NoGPOListChanges.ps1
#>

# Ensure script is running as Administrator
$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# Registry configuration
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
$valueName    = "NoGPOListChanges"
$valueType    = "DWord"
$valueData    = 0

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

    Write-Host "Successfully set NoGPOListChanges to 0." -ForegroundColor Green

    # Verification
    $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName
    Write-Host "Verified setting:" -ForegroundColor Cyan
    Write-Host "$valueName = $($currentValue.$valueName)" -ForegroundColor Cyan
}
catch {
    Write-Error "Failed to configure registry value. Error: $($_.Exception.Message)"
    exit 1
}
