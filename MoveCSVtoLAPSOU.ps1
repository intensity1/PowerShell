$Servers = Get-Content C:\1\PCsresponsiblefor.csv

Foreach ($Server in $Servers)

{
Get-ADComputer $server | Move-ADObject -TargetPath "OU=Servers-LAPS,OU=SunbeamInfrastructure,DC=sunbeamproducts,DC=sunbeam,DC=com" -Verbose
} 