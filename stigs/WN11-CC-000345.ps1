<#
.SYNOPSIS
    This PowerShell script ensures Basic authentication is disabled for WinRM Service by setting the
    'AllowBasic' registry value to 0, in compliance with Windows 11 STIG requirements.

.NOTES
    Author          : Saran Deny
    LinkedIn        : linkedin.com/in/saran-deny
    GitHub          : github.com/sarandeny
    Date Created    : 2026-04-15
    Last Modified   : 2026-04-15
    Version         : 1.0
    STIG-ID         : WN11-CC-000345
    STIG Title      : Disable Basic authentication for WinRM Service
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-CC-000330/
    
    Description     :
        This script remediates a security misconfiguration by disabling Basic authentication
        for Windows Remote Management (WinRM). Basic authentication transmits credentials in a weak
        format and is not recommended in secure environments.

        This control aligns with secure configuration baselines and helps reduce the risk of
        credential exposure during remote management operations.

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run this script in an elevated PowerShell session.

    Example:
    PS C:\> .\WN11-CC-000330_Remediation.ps1

    Verification:
    Check the registry value:
    HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service\AllowBasic
    Expected value: 0
#>

# Define registry path and value details
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"
$valueName = "AllowBasic"
$desiredValue = 0

try {
    Write-Host "[*] Checking registry path..."

    # Ensure the registry path exists
    if (-not (Test-Path $registryPath)) {
        Write-Host "[+] Path not found. Creating registry path..."
        New-Item -Path $registryPath -Force | Out-Null
    }

    Write-Host "[*] Applying STIG remediation..."

    # Create or update the registry value
    New-ItemProperty -Path $registryPath `
        -Name $valueName `
        -Value $desiredValue `
        -PropertyType DWord `
        -Force | Out-Null

    Write-Host "[+] Remediation successful."
    Write-Host "[+] '$valueName' is now set to '$desiredValue'."

}
catch {
    Write-Error "[!] Remediation failed: $($_.Exception.Message)"
    exit 1
}
