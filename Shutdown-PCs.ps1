## Restart-Computer 


#get list of PCs
$Computers = get-content C:\1\restartpcs.csv

#Restart them
Stop-Computer $Computers -Verbose -force

#wait 5 minutes

Start-Sleep -s 300

#ping computers to see if they respond

Test-Connection -count 1 -computer $computers