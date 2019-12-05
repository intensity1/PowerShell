$collectionname = "103127 - Manual"

$computers = Get-Content "C:\1\Scratch\CMCol\103127 - Manual.txt" 
    foreach($computer in $computers) { 
       
          Add-CMDeviceCollectionDirectMembershipRule  -CollectionName $collectionname -ResourceId $(get-cmdevice -Name $computer).ResourceID -Verbose
    
         }