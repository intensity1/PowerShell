$collectionname = "PSADT - Silverlight Removal"

$computers = Get-Content "C:\1\Scratch\CMCol\SLRemoval.txt" 
    foreach($computer in $computers) { 
       
          Add-CMDeviceCollectionDirectMembershipRule  -CollectionName $collectionname -ResourceId $(get-cmdevice -Name $computer).ResourceID -Verbose
    
         }