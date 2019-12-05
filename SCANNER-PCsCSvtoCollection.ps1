$collectionname = "Scanner PCs"

$computers = Get-Content "C:\1\scratch\cmcol\scannerpcs.txt" 
    foreach($computer in $computers) { 
       
          Add-CMDeviceCollectionDirectMembershipRule  -CollectionName $collectionname -ResourceId $(get-cmdevice -Name $computer).ResourceID -Verbose
    
         }