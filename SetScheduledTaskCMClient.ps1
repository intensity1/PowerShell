$taskname = ‘SCCM Client Remediation’

Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue |  Unregister-ScheduledTask -Confirm:$false

$triggers = @()
$triggers += New-ScheduledTaskTrigger -Weekly -At 11am -DaysOfWeek Friday
$triggers += New-ScheduledTaskTrigger -AtLogOn

$actionscript = '-executionPolicy Bypass -File "\\flmirnetappcifs\SCCM\PS\SWSAD\ConfigMgrClientHealth.ps1" -Config "\\flmirnetappcifs\SCCM\PS\SWSAD\config.xml"'

$pstart =  “C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe”

$action = New-ScheduledTaskAction -Execute $pstart -Argument $actionscript
Register-ScheduledTask -TaskName $taskname -Action $action -Trigger $triggers -RunLevel Highest -Description “SCCM Client Remediation”