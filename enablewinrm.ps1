$Computers = get-content C:\1\telli.csv

Foreach ($Computer in $Computers)

{
C:\1\enablewinrm\enablewinrm.ps1 -computerName $Computer
}