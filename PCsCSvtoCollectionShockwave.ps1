$collectionname = "PSADT - Shockwave Removal"

$computers = Get-Content "C:\1\scratch\cmcol\PSADT - SW.txt" 
    foreach($computer in $computers) { 
       
          Add-CMDeviceCollectionDirectMembershipRule  -CollectionName $collectionname -ResourceId $(get-cmdevice -Name $computer).ResourceID -Verbose
    
         }