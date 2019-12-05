$computername = import-csv C:\1\IE11\Reporting\InternetExplorerVersion.csv | % {$_.Details_Table0_Netbios_Name0}


Foreach ($Computer in $Computername)

{
Get-ADComputer -Identity $computer -Properties OperatingSystem,OperatingSystemServicePack
}