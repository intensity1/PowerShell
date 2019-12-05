#Where are you searching?
#-------------------------------------------SWSCA
#$domain = "swsca"
$Domaincontroller = "SWSAD1"
#----------------------------------------------


#-------------------------------------------Sunbeam
#$domain = "sunbeamproducts"
#$Domaincontroller = "bocfl-SBdc01"
#----------------------------------------------

#-------------------------------------------Venezuela
#$domain = "venezuela.sunbeam.com"
#$Domaincontroller = "barve-vedc02"
#----------------------------------------------

#-------------------------------------------mexico
#$domain = "mexicana"
#$Domaincontroller = "mexmx-mxdcfp01"
#----------------------------------------------#Where are you searching?
#-------------------------------------------CAN
#$domain = "canada"
#$Domaincontroller = "bocfl-cndc01"
#----------------------------------------------


#-------------------------------------------Sunbeam
#$domain = "sunbeamproducts"
#$Domaincontroller = "bocfl-SBdc01"
#----------------------------------------------

#-------------------------------------------Venezuela
#$domain = "venezuela.sunbeam.com"
#$Domaincontroller = "barve-vedc02"
#----------------------------------------------

#-------------------------------------------mexico
#$domain = "mexicana"
#$Domaincontroller = "mexmx-mxdcfp01"
#----------------------------------------------#Where are you searching?
#-------------------------------------------CAN
#$domain = "canada"
#$Domaincontroller = "bocfl-cndc01"
#----------------------------------------------


#-------------------------------------------Sunbeam
#$domain = "sunbeamproducts"
#$Domaincontroller = "bocfl-SBdc01"
#----------------------------------------------

#-------------------------------------------Venezuela
#$domain = "venezuela.sunbeam.com"
#$Domaincontroller = "barve-vedc02"
#----------------------------------------------

#-------------------------------------------mexico
#$domain = "mexicana"
#$Domaincontroller = "mexmx-mxdcfp01"
#----------------------------------------------

#What are you searching for ?
$like = '*CM-LABVM*'


Get-ADComputer -Searchbase “dc=swsad,dc=com” -Server $Domaincontroller -Properties DNSHostName -Filter { DNSHostName -Like $like } | Select DNSHostName | Sort DNSHostName
