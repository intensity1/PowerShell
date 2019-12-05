l##Var
$Computers = get-content C:\1\Scratch\CMCol\1.txt


#setup loop
$TimeStart = Get-Date
$TimeEnd = $timeStart.addminutes(30)
Write-Host "Start Time: $TimeStart"
write-host "End Time:   $TimeEnd"
Do { 
 $TimeNow = Get-Date
 if ($TimeNow -ge $TimeEnd) 
 {

Restart-Computer $Computers -Verbose -force


 } 
 
 else {
  Write-Host "Not done yet, it's only $TimeNow"
 }
 Start-Sleep -Seconds 10
}
Until ($TimeNow -ge $TimeEnd)     