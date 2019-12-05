 #VARS
$domainname = (gwmi win32_computersystem).Domain
$powershell = get-host|select -ExpandProperty Version
    #pending updates
$criteria = "Type='software' and IsAssigned=1 and IsHidden=0 and IsInstalled=0"

$searcher = (New-Object -COM Microsoft.Update.Session).CreateUpdateSearcher()
$updates  = $searcher.Search($criteria).Updates




#OS
Get-WmiObject win32_operatingsystem | select -ExpandProperty Caption

#Joined to domain
if ((gwmi win32_computersystem).partofdomain -eq $true) {
    write-host -fore green "Machine IS Domain joined"
    Write-Host "Domain name is $domainname" -ForegroundColor Green
} else {
    write-host -fore red "Machine is NOT domain joined"
}

#PowerShell Version

Write-Host -ForegroundColor Yellow "Powershell version is $powershell"



#CCM Service
if (Get-Service "CCmExec" -ErrorAction SilentlyContinue)
{
Write-Host "System Center Configuration Manager (SCCM) Client IS installed" -ForegroundColor Green
}
else
{
Write-Host "System Center Configuration Manager (SCCM) Client IS NOT installed" -ForegroundColor Red
}



#CCM Service
if (Get-Service "Sense" -ErrorAction SilentlyContinue)
{
Write-Host "Windows Defender client IS installed" -ForegroundColor Green
}
else
{
Write-Host "Windows Defender client IS NOT installed" -ForegroundColor Red
}


#Pending reboot

$rebootpending = Invoke-WmiMethod -Namespace "ROOT\ccm\ClientSDK" -Class "CCM_ClientUtilities" -Name DetermineIfRebootPending | Select-Object DetermineIfRebootPending
Write-Host -ForegroundColor White "Pending Reboot is $rebootpending"


#pending updates
write-host -ForegroundColor Yellow "Pending update count is "$updates.Count""



#Updates
#__________________________________________________________________________________________________________
try{
	$session = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session",$ComputerName))
	$updateSearcher = $session.CreateUpdateSearcher()
	$updateHistoryCount = $updateSearcher.GetTotalHistoryCount()
}catch [Exception]{
		Write-Host "Cannot connect to Windows Update service"
		Write-Host $_.Exception.Message
		$host.SetShouldExit(1005) 
		exit 1005
}

if ( $updateHistoryCount -le 0 ){

	[Nullable[datetime]]$FeatureUpdateInstallDate 
	Try{
		[datetime]$FeatureUpdateInstallDate = (Get-CimInstance Win32_OperatingSystem -ErrorAction Stop).InstallDate
	}Catch [Exception]{
		[datetime]$FeatureUpdateInstallDate = ((get-date -year 1970 -month 1 -day 1 -hour 0 -minute 0 -second 0).AddSeconds((get-itemproperty -path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -name InstallDate).InstallDate)).ToLocalTime().AddHours((get-date -f zz))
	}
	
	if ( ($FeatureUpdateInstallDate.installDate -gt (Get-Date).AddDays(-45)) -and ($NULL -ne $FeatureUpdateInstallDate) ){
		$FeatureUpdateDateDiff = [int][Math]::Ceiling((New-Timespan -Start $FeatureUpdateInstallDate.installDate -End (Get-Date) ).TotalDays)
		Write-Host "Last feature update was $FeatureUpdateDateDiff days ago."
		$host.SetShouldExit(0) 
		exit 0
	} else {
		Write-Host -ForegroundColor Red "No updates found in update history."
		$host.SetShouldExit(1004) 
		exit 1005
	}
}

$updateHistory = $updateSearcher.QueryHistory(0, $updateHistoryCount)

[int]$UpdatesToInstallCount = 0
[string]$UpdatesToInstall = ""

[int]$FailedUpdatesCount = 0
[string]$FailedUpdates = ""

[int]$FailedUpdatesTotalCount = 0
[string]$FailedUpdatesTotal = ""

[int]$UpdatesWithinLast2Months = 0
[string]$InstalledUpdates = ""

[DateTime]$LastUpdateAt = (Get-Date -Date "1970-01-01 00:00:00Z").ToUniversalTime()
[string]$LastUpdate = ""

foreach ($Upd in $updateHistory) {
    if ((($Upd.operation -eq 1 -and $Upd.resultcode -eq 0) -or ($Upd.operation -eq 1 -and $Upd.resultcode -eq 1)) -and (($Upd.ClientApplicationID -eq "UpdateOrchestrator") -or ($Upd.ClientApplicationID -eq "AutomaticUpdates") -or ($Upd.ClientApplicationID -eq "AutomaticUpdatesWuApp"))) {
        $UpdatesToInstall += $Upd.Title + "`n"
        $UpdatesToInstallCount++
    }
	
	if ((($Upd.operation -eq 1 -and $Upd.resultcode -eq 4) -or ($Upd.operation -eq 1 -and $Upd.resultcode -eq 5)) -and (($Upd.ClientApplicationID -eq "UpdateOrchestrator") -or ($Upd.ClientApplicationID -eq "AutomaticUpdates") -or ($Upd.ClientApplicationID -eq "AutomaticUpdatesWuApp"))) {
		if (([DateTime]$Upd.Date) -gt (Get-Date).AddHours(-23)){
			$FailedUpdates += $Upd.Title + "`n"
			$FailedUpdatesCount++
		}
		$FailedUpdatesTotal += $Upd.Title + "`n"
		$FailedUpdatesTotalCount++
    }
	
	if (((($Upd.operation -eq 1 -and $Upd.resultcode -eq 2) -or ($Upd.operation -eq 1 -and $Upd.resultcode -eq 3)) -and (($Upd.ClientApplicationID -eq "UpdateOrchestrator") -or ($Upd.ClientApplicationID -eq "AutomaticUpdates") -or ($Upd.ClientApplicationID -eq "AutomaticUpdatesWuApp"))) -and ([DateTime]$Upd.Date) -gt (Get-Date).AddDays(-45)) {
        $InstalledUpdates += ([DateTime]$Upd.Date).ToShortDateString() + " | " + $Upd.Title + "`n"
        $UpdatesWithinLast2Months++
    }
	
	if (((($Upd.operation -eq 1 -and $Upd.resultcode -eq 2) -or ($Upd.operation -eq 1 -and $Upd.resultcode -eq 3)) -and (($Upd.ClientApplicationID -eq "UpdateOrchestrator") -or ($Upd.ClientApplicationID -eq "AutomaticUpdates") -or ($Upd.ClientApplicationID -eq "AutomaticUpdatesWuApp"))) -and ([DateTime]$Upd.Date -gt $LastUpdateAt)){
		$LastUpdateAt = [DateTime]$Upd.Date
		$LastUpdate = $Upd.Title
	}
}

[string]$LastUpdateAtDate = $LastUpdateAt.ToLongDateString()

if ($LastUpdateAt -eq (Get-Date -Date "1970-01-01 00:00:00Z").ToUniversalTime()){
	Write-Host -ForegroundColor Red "No successful update found in update history.`n"
	if ($UpdatesToInstallCount -gt 0){
		Write-Host -ForegroundColor Yellow "$UpdatesToInstallCount waiting for installation/reboot:`n$UpdatesToInstall"
	}
	if ($FailedUpdatesTotalCount -gt 0){
		Write-Host -ForegroundColor Red "Error while installing $FailedUpdatesTotalCount updates:`n$FailedUpdatesTotal"
	}
	$host.SetShouldExit(1003) 
    exit 1003
}elseif ( $FailedUpdatesCount -gt 0 ){
    Write-Host -ForegroundColor Red "Error while installing  $FailedUpdatesCount updates:`n$FailedUpdates"
	Write-Host "Last update installed on $LastUpdateAtDate ($LastUpdate)"
	$host.SetShouldExit(1002) 
    exit 1002
}elseif ( $UpdatesWithinLast2Months -le 0 ){
    Write-Host -ForegroundColor Red "No updates have been installed within the last 45 days`n"
	if ($UpdatesToInstallCount -gt 0){
		Write-Host "$UpdatesToInstallCount waiting for installation/reboot:`n$UpdatesToInstall"
	}
	Write-Host "Last update installed on $LastUpdateAtDate ($LastUpdate)"
	$host.SetShouldExit(1001) 
	exit 1001
}else{
    Write-Host -ForegroundColor Green "No updates failed to install.`n"
	Write-Host "$UpdatesWithinLast2Months installed updates in the last 45 days:`n$InstalledUpdates"
	if ($UpdatesToInstallCount -gt 0){
		Write-Host "$UpdatesToInstallCount waiting for installation/reboot:`n$UpdatesToInstall"
	}
}
#ENDUPDATES