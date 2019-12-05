@"
===============================================================================
Title:         vminventory.ps1
Description:   Exports VM Information from vCenter into a .CSV file for importing into anything
Usage:         .\vminventory.ps1
Date:          10/15/2012
===============================================================================
"@
#### Get Virtual Center To Connect to:
$VCServerName = "flmir-vcsa1"
$ExportFilePath = Read-Host "Where do you want to export the data?"
$VC = Connect-VIServer $VCServerName
$Report = @()
#$VMs = Get-Folder $VMFolder | Get-VM
$VMs = get-vm |Where-object {$_.powerstate -eq "poweredoff"}
$Datastores = Get-Datastore | select Name, Id
$VMHosts = Get-VMHost | select Name, Parent
### Get powered off event time:
ForEach ($VM in $VMs) {
Get-VIEvent -Entity $VM -MaxSamples ([int]::MaxValue) | where {$_ -is [VMware.Vim.VmPoweredOffEvent]} |
Group-Object -Property {$_.Vm.Name} | %{
$lastPO = $_.Group | Sort-Object -Property CreatedTime -Descending | Select -First 1 | Select -ExpandProperty CreatedTime
New-Object PSObject -Property @{
VM = $_.Group[0].Vm.Name
  "Last Poweroff"= $lastPO
}
}
      $VMView = $VM | Get-View
      $VMInfo = {} | Select VMName,Powerstate,OS,IPAddress,ToolsStatus,Host,Cluster,Datastore,NumCPU,MemMb,DiskGb,SSGOwner,BUSowner,PowerOFF,Note
      $VMInfo.VMName = $vm.name
      $VMInfo.Powerstate = $vm.Powerstate
      $VMInfo.OS = $vm.Guest.OSFullName
      $VMInfo.IPAddress = $vm.Guest.IPAddress[0]
      $VMInfo.ToolsStatus = $VMView.Guest.ToolsStatus
      $VMInfo.Host = $vm.host.name
      $VMInfo.Cluster = $vm.host.Parent.Name
      $VMInfo.Datastore = ($Datastores | where {$_.ID -match (($vmview.Datastore | Select -First 1) | Select Value).Value} | Select Name).Name
      $VMInfo.NumCPU = $vm.NumCPU
      $VMInfo.MemMb = [Math]::Round(($vm.MemoryMB),2)
      $VMInfo.DiskGb = [Math]::Round((($vm.HardDisks | Measure-Object -Property CapacityKB -Sum).Sum * 1KB / 1GB),2)
      $VMInfo.PowerOFF = $lastPO
      $VMInfo.Note = $vm.Notes
      $Report += $VMInfo
}
$Report = $Report | Sort-Object VMName
IF ($Report -ne "") {
$report | Export-Csv $ExportFilePath -NoTypeInformation
}
$VC = Disconnect-VIServer $VCServerName -Confirm:$False