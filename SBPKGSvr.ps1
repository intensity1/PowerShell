$Sitecodes = Get-Content C:\2\PCsResponsiblefor\sitecodes.csv

Foreach ($sitecode in $sitecodes)


{
write-host "\\$sitecode-sbpkgsvr\mdt_$sitecode$"
}