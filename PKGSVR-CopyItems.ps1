$Computers = get-content C:\1\sbpkgsvr.txt

Foreach ($Computer in $Computers)

{
restart-computer $computer -force -verbos
}