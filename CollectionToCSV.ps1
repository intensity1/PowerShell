$collectionname = "100760,103127 Deployment Server Group"

$computers = Get-Content "C:\1\Scratch\CMCol\1.txt" 
    foreach($computer in $computers) { 
       
          Add-CMDeviceCollectionDirectMembershipRule  -CollectionName $collectionname -ResourceId $(get-cmdevice -Name $computer).ResourceID -Verbose
    
         }