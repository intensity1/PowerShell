$Computers = get-content C:\1\PCsresponsiblefor.csv

Foreach ($Computer in $Computers)

{
Get-ADComputer -Identity $Computer -Property * | Where-Object -Property "OperatingSystem" -EQ "Windows Server 2003" | Format-Table Name,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion -Wrap –Auto
}