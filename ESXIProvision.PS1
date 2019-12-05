$OldPassword = "~sgws{SCCM}"
$NewPassword = ([char[]]([char]33..[char]95) + ([char[]]([char]97..[char]126)) + 0..9 | sort {Get-Random})[0..8] -join ''
$VIServer = Read-Host "Enter New HOST IP Address"
$Credentials = Get-Credential
$NewName = TXELP-ESXP


#connects to server
Connect-VIServer $VIServer -User root -Password $OldPassword
Start-Sleep -Seconds 10

#changes password
Get-VMHostAccount -User root |  Set-VMHostAccount -Password $NewPassword

#Rename


#joins to SGWS Domain
Set-VMHostAuthentication -JoinDomain -Domain sgws.com -Username $Credentials -Password $Credentials

#adds to vcenter
Add-VMHost -Name gaatl-vcsap01.sgws.com -User $Credentials -Password $Credentials



#joins to SGWS Domain
Set-VMHostAuthentication -JoinDomain -Domain sgws.com -Username $Credentials -Password $Credentials

Write-host  "ESX Server $newname has been provisioned with password set to $NewPassword" -ForegroundColor Magenta