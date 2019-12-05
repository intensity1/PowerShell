#Jose R. Esposito 02/18/2016
#Purpose: Exporting Bitlocker objects to a share for EUS Staff to retrieve in the chance that they delete the Computer Object out of AD

#Import - Module 
Import-Module ActiveDirectory

# get today's date, used to create folder path
$today = Get-Date

#Used to create folder 
$newfolder = (Get-Date).ToString('yyyy-MM-dd')

#create directory with the csv I.E. \\Server01\bitlocker$\2016-02-18\
New-Item -ItemType Directory -Path "\\orlfl-sbaltp02\bitlocker$\RecoveryPasswords\$((Get-Date).ToString('yyyy-MM-dd'))" -ErrorAction SilentlyContinue

#Path the .csv will be output to
$Path = "\\orlfl-sbaltp02\bitlocker$\RecoveryPasswords\$newfolder\BitlockerRecoveryKeys.csv"


#-----------------------------------------------------------------------------------------
#Canada
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "bocfl-cndc01"
$domain = "canada"

get-adcomputer -Searchbase “dc=$domain,dc=sunbeam,dc=com” -Server $domaincontroller -filter * |% {

write-host $_.name

get-ADObject -ldapfilter “(msFVE-Recoverypassword=*)” -Searchbase $_.distinguishedname -properties canonicalname,msfve-recoverypassword -Server $domaincontroller | select canonicalname,msfve-recoverypassword | Export-Csv -Path $path -Append}

#-----------------------------------------------------------------------------------------
#SunbeamProducts
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "ATLGA-SBDC01"
$domain = "sunbeamproducts"

get-adcomputer -Searchbase “dc=$domain,dc=sunbeam,dc=com” -Server $domaincontroller -filter * |% {

write-host $_.name

get-ADObject -ldapfilter “(msFVE-Recoverypassword=*)” -Searchbase $_.distinguishedname -properties canonicalname,msfve-recoverypassword -Server $domaincontroller | select canonicalname,msfve-recoverypassword | Export-Csv -Path $Path -Append}
#-----------------------------------------------------------------------------------------
#fareast
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "ATLGA-FEDC01"
$domain = "fareast"

get-adcomputer -Searchbase “dc=$domain,dc=sunbeam,dc=com” -Server $domaincontroller -filter * |% {

write-host $_.name

get-ADObject -ldapfilter “(msFVE-Recoverypassword=*)” -Searchbase $_.distinguishedname -properties canonicalname,msfve-recoverypassword -Server $domaincontroller | select canonicalname,msfve-recoverypassword | Export-Csv -Path $Path -Append}
#-----------------------------------------------------------------------------------------
#Mexicana
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "ATLGA-MXDC01"
$domain = "mexicana"

get-adcomputer -Searchbase “dc=$domain,dc=sunbeam,dc=com” -Server $domaincontroller -filter * |% {

write-host $_.name

get-ADObject -ldapfilter “(msFVE-Recoverypassword=*)” -Searchbase $_.distinguishedname -properties canonicalname,msfve-recoverypassword -Server $domaincontroller | select canonicalname,msfve-recoverypassword | Export-Csv -Path $Path -Append}
#-----------------------------------------------------------------------------------------
#Mexicana
#-----------------------------------------------------------------------------------------

#specify domain controller to service information lookup
$domaincontroller = "ATLGA-VEDC01"
$domain = "venezuela"

get-adcomputer -Searchbase “dc=$domain,dc=sunbeam,dc=com” -Server $domaincontroller -filter * |% {

write-host $_.name

get-ADObject -ldapfilter “(msFVE-Recoverypassword=*)” -Searchbase $_.distinguishedname -properties canonicalname,msfve-recoverypassword -Server $domaincontroller | select canonicalname,msfve-recoverypassword | Export-Csv -Path $Path -Append}