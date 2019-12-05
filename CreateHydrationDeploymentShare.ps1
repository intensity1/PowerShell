<#
.Synopsis
    Sample script for Hydration Kit
.DESCRIPTION
    Created: 2015-10-06
    Version: 1.1

    Author : Johan Arwidmark
    Twitter: @jarwidmark
    Blog   : http://deploymentresearch.com

    Disclaimer: This script is provided "AS IS" with no warranties, confers no rights and 
    is not supported by the author or DeploymentArtist..
.EXAMPLE
    NA
#>


# Check for elevation
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Oupps, you need to run this script from an elevated PowerShell prompt!`nPlease start the PowerShell prompt as an Administrator and re-run the script."
	Write-Warning "Aborting script..."
    Break
}

# Verify that MDT 2013 Update 1 is installed
if (!(Test-Path -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7960529F-584E-4243-ABED-DDC5C653E23D}")) {Write-Warning "MDT 2013 Update 1 is not installed, aborting...";Break}

# Verify that Windows ADK 10 build 10240 is installed

# Check free space on C: - Minimum for the Hydration Kit is 50 GB
$NeededFreeSpace = "53687091200"
$disk = Get-wmiObject Win32_LogicalDisk -computername . | where-object {$_.DeviceID -eq "C:"} 

[float]$freespace = $disk.FreeSpace;
$freeSpaceGB = [Math]::Round($freespace / 1073741824);

if($disk.FreeSpace -lt $NeededFreeSpace)
{
Write-Warning "Oupps, you need at least 50 GB of free disk space"
Write-Warning "Available free space on C: is $freeSpaceGB GB"
Write-Warning "Aborting script..."
Write-Host ""
Write-Host "TIP: If you don't have space on C: but have other volumes, say D:, available, " -ForegroundColor Yellow
Write-Host "then copy the HydrationCM folder to D: and use mklink to create a synlink on C:" -ForegroundColor Yellow
Write-Host "The syntax is: mklink C:\HydrationCM D:\HydrationCM /D" -ForegroundColor Yellow
Break
}

# Validation OK, create Hydration Deployment Share
$MDTServer = (get-wmiobject win32_computersystem).Name

Add-PSSnapIn Microsoft.BDD.PSSnapIn -ErrorAction SilentlyContinue 
md C:\HydrationCM\DS
new-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "C:\HydrationCM\DS" -Description "Hydration ConfigMgr" -NetworkPath "\\$MDTServer\HydrationCM$" | add-MDTPersistentDrive
New-SmbShare –Name HydrationCM$ –Path "C:\HydrationCM\DS"  –ChangeAccess EVERYONE

md C:\HydrationCM\ISO\Content\Deploy
new-item -path "DS001:\Media" -enable "True" -Name "MEDIA001" -Comments "" -Root "C:\HydrationCM\ISO" -SelectionProfile "Everything" -SupportX86 "False" -SupportX64 "True" -GenerateISO "True" -ISOName "HydrationCM.iso"
new-PSDrive -Name "MEDIA001" -PSProvider "MDTProvider" -Root "C:\HydrationCM\ISO\Content\Deploy" -Description "Hydration ConfigMgr Media" -Force

# Configure MEDIA001 Settings (disable MDAC) for bug in ADK 10240
Set-ItemProperty -Path MEDIA001: -Name Boot.x86.FeaturePacks -Value ""
Set-ItemProperty -Path MEDIA001: -Name Boot.x64.FeaturePacks -Value ""

# Copy sample files to Hydration Deployment Share
Copy-Item -Path "C:\HydrationCM\Source\Hydration\Applications" -Destination "C:\HydrationCM\DS" -Recurse -Force
Copy-Item -Path "C:\HydrationCM\Source\Hydration\Control" -Destination "C:\HydrationCM\DS" -Recurse -Force
Copy-Item -Path "C:\HydrationCM\Source\Hydration\Operating Systems" -Destination "C:\HydrationCM\DS" -Recurse -Force
Copy-Item -Path "C:\HydrationCM\Source\Hydration\Scripts" -Destination "C:\HydrationCM\DS" -Recurse -Force
Copy-Item -Path "C:\HydrationCM\Source\Media\Control" -Destination "C:\HydrationCM\ISO\Content\Deploy" -Recurse -Force
