#-----------------
#Define Variables
#-----------------
$Software = "LANrev Agent"

#LANrev Agent

#-----------------
#Search software
#-----------------
if ((Get-WmiObject -class SMS_InstalledSoftware -Namespace "root\cimv2\sms" | 
Where-Object {$_.ProductName -like "*$Software*"}) -eq $null ) { $results = 0} else {$results = 1}

return $results
