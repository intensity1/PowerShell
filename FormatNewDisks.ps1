#MustRunSeprately


Initialize-Disk -PassThru -number 1 -PartitionStyle MBR 


New-Partition -DiskNumber 1 -UseMaximumSize -DriveLetter "O"



 Format-Volume -DriveLetter O -NewFileSystemLabel "RoadNet"