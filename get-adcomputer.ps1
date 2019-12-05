$path = "C:\1\CSVs\testing\output.csv"
$computers = get-content "C:\1\CSVs\1.txt"

#SWSAD
$DC = "DCP02.sgws.com"
ForEach ($computer in $computers)

{

Get-ADComputer -Identity $computer -Properties * -Server $DC | Select Name,OperatingSystem,OperatingSystemServicePack,LastLogonDate,IPV4Address |Export-Csv -Path $path -Append -Verbose

}