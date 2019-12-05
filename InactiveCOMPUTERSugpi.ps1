#Jose R. Esposito 02/18/2016
#Purpose: Exporting Bitlocker objects to a share for EUS Staff to retrieve in the chance that they delete the Computer Object out of AD

#-----------------------------------------------------------------------------------------
#Variables
#-----------------------------------------------------------------------------------------

#Import - Module 
Import-Module ActiveDirectory

# get today's date, used to create folder path
$today = Get-Date

#Used to create folder 
$newfolder = (Get-Date).ToString('yyyy-MM-dd')

#create directory with the csv I.E. \\Server01\bitlocker$\2016-02-18\
New-Item -ItemType Directory -Path "C:\2\ClientInventory\$((Get-Date).ToString('yyyy-MM-dd'))" -ErrorAction SilentlyContinue -Verbose

#Path the .csv will be output to
$Path = "C:\2\ClientInventory\$newfolder\report.csv"

#Get today - 90 days 32 month old)
$cutoffdate = $today.AddDays(-90)



#-----------------------------------------------------------------------------------------
#Canada
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "mia1dc01"
$domain = "uspgi"

##Filter On

##Get-ADComputer  -Properties * -Filter {LastLogonDate -ge $cutoffdate} -SearchBase "dc=$domain,dc=sunbeam,dc=com" -Server $domaincontroller | Select Name,OperatingSystem,OperatingSystemVersion,LastLogonDate,CanonicalName,distinguishedname |Where-Object DistinguishedName -like "server"|Export-Csv -Path $Path -Append

##Filter off
Get-ADComputer  -Properties * -Filter {LastLogonTimestamp -lt $cutoffdate} -SearchBase "dc=$domain,dc=com" -Server $domaincontroller | Select Name,OperatingSystem,OperatingSystemVersion,LastLogonDate,CanonicalName,distinguishedname |Export-Csv -Path $Path -Append

#-----------------------------------------------------------------------------------------
