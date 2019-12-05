$collectionname = "105552,105553,105548,106796,108290,108291,111685,111688,111689 Server Group"

$computers = Get-Content "C:\1\Scratch\CMCol\1.txt" 
    foreach($computer in $computers) { 
       
          Add-CMDeviceCollectionDirectMembershipRule  -CollectionName $collectionname -ResourceId $(get-cmdevice -Name $computer).ResourceID -Verbose
    
         }