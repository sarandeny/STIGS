<#
.SYNOPSIS
    This PowerShell script disables Windows consumer features by setting the
    DisableWindowsConsumerFeatures policy value to 1.

.NOTES
    Author          : Saran Deny
    LinkedIn        : linkedin.com/in/saran-deny
    GitHub          : github.com/sarandeny
    Date Created    : 2026-04-13
    Last Modified   : 2026-04-13
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000197
    Documentation   : N/A

.TESTED ON
    Date(s) Tested  :
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run this script in an elevated PowerShell session.
    Example syntax:
    PS C:\> .\Disable-WindowsConsumerFeatures.ps1
#>

# Define registry path and value details
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$valueName    = "DisableWindowsConsumerFeatures"
$valueData    = 1

try {
    # Create registry path if it does not exist
    if (-not (Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Created registry path: $registryPath"
    }

    # Create or update the DWORD value
    New-ItemProperty -Path $registryPath `
                     -Name $valueName `
                     -Value $valueData `
                     -PropertyType DWord `
                     -Force | Out-Null

    Write-Host "$valueName has been successfully set to $valueData." -ForegroundColor Green
}
catch {
    Write-Host "Failed to apply registry setting: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
