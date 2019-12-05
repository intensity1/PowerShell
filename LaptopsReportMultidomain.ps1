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
New-Item -ItemType Directory -Path "C:\2\ClientInventory\$((Get-Date).ToString('yyyy-MM-dd'))" -ErrorAction SilentlyContinue

#Path the .csv will be output to
$Path = "C:\2\ClientInventory\$newfolder\Laptops.csv"

#Get today - 60 days (2 month old)
$cutoffdate = $today.AddDays(-90)



#-----------------------------------------------------------------------------------------
#Canada
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "bocfl-cndc01"
$domain = "canada"


Get-ADComputer  -Properties * -Filter {LastLogonDate -ge $cutoffdate} -SearchBase "dc=$domain,dc=sunbeam,dc=com" -Server $domaincontroller | Select Name,OperatingSystem,OperatingSystemVersion,LastLogonDate,CanonicalName,distinguishedname |Where-Object DistinguishedName -like "*laptops*"|Export-Csv -Path $Path -Append
#-----------------------------------------------------------------------------------------
#SunbeamProducts
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "ATLGA-SBDC01"
$domain = "sunbeamproducts"

Get-ADComputer  -Properties * -Filter {LastLogonDate -ge $cutoffdate} -SearchBase "dc=$domain,dc=sunbeam,dc=com" -Server $domaincontroller | Select Name,OperatingSystem,OperatingSystemVersion,LastLogonDate,CanonicalName,distinguishedname |Where-Object DistinguishedName -like "*laptops*"|Export-Csv -Path $Path -Append

#-----------------------------------------------------------------------------------------
#fareast
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "ATLGA-FEDC01"
$domain = "fareast"


Get-ADComputer  -Properties * -Filter {LastLogonDate -ge $cutoffdate} -SearchBase "dc=$domain,dc=sunbeam,dc=com" -Server $domaincontroller | Select Name,OperatingSystem,OperatingSystemVersion,LastLogonDate,CanonicalName,distinguishedname |Where-Object DistinguishedName -like "*laptops*"|Export-Csv -Path $Path -Append
#-----------------------------------------------------------------------------------------
#Mexicana
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "ATLGA-MXDC01"
$domain = "mexicana"


Get-ADComputer  -Properties * -Filter {LastLogonDate -ge $cutoffdate} -SearchBase "dc=$domain,dc=sunbeam,dc=com" -Server $domaincontroller | Select Name,OperatingSystem,OperatingSystemVersion,LastLogonDate,CanonicalName,distinguishedname |Where-Object DistinguishedName -like "*laptops*"|Export-Csv -Path $Path -Append
#-----------------------------------------------------------------------------------------
#Venezuela
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "ATLGA-VEDC01"
$domain = "venezuela"


Get-ADComputer  -Properties * -Filter {LastLogonDate -ge $cutoffdate} -SearchBase "dc=$domain,dc=sunbeam,dc=com" -Server $domaincontroller | Select Name,OperatingSystem,OperatingSystemVersion,LastLogonDate,CanonicalName,distinguishedname |Where-Object DistinguishedName -like "*laptops*"|Export-Csv -Path $Path -Append