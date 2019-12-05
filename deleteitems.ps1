$Computers = get-content C:\1\SunbeamB.csv


Foreach ($computer in $computers)
{

rd "C:\Documents and Settings\All Users\Desktop\SunbeamB.ws.lnk"
rd "C:\Program Files\IBM\Client Access\Emulator\Private\SunbeamB.ws"
rd "C:\users\Public\Desktop\SunbeamB.ws.lnk"

}