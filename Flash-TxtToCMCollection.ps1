$collectionname = "PSADT - Flash Player"

$computers = Get-Content "C:\1\scratch\cmcol\PSADT - flash.txt" 
    foreach($computer in $computers) { 
       
          Add-CMDeviceCollectionDirectMembershipRule  -CollectionName $collectionname -ResourceId $(get-cmdevice -Name $computer).ResourceID -Verbose
    
         }