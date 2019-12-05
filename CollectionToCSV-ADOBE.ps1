$collectionname = "PSADT - Adobe Deploy"

$computers = Get-Content "C:\1\Scratch\CMCol\PSADT - Adobe Deploy.txt" 
    foreach($computer in $computers) { 
       
          Add-CMDeviceCollectionDirectMembershipRule  -CollectionName $collectionname -ResourceId $(get-cmdevice -Name $computer).ResourceID -Verbose
    
         }