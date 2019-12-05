function Rename-VMHost {
 
<#  
.SYNOPSIS  Renames an ESXi server   
.DESCRIPTION The function will rename an ESXi 5.x server.
  The function follows VMware KB1010821
.NOTES  Author:  Luc Dekens  
.PARAMETER VMHost
  The ESXi server to be renamed
.PARAMETER Credential
  The credentials to connect to the ESXi 5.x server
.PARAMETER NewName
  The new FQDN 
.PARAMETER Location
  By default the ESXi server will stay in its current location.
  You can specify a Datacenter or Cluster for the newly named
  ESXi 5.x server.
.PARAMETER MaintenanceMode
  Although not required by KB1010821, by default the function
  places the ESXi 5.x server in maintenance mode, before doing
  the rename.
.PARAMETER DnsCheck
  When this switch is set, the function will first check if the
  new name for the ESXi host can be resolved with DNS.
.EXAMPLE
  PS> Rename-VMHost -VMHost $esx -NewName "newname.lucd.info"
#>
 
  [CmdletBinding()] 
  param(
    [PSObject]$VMHost,
    [System.Management.Automation.PSCredential]$Credential,
    [string]$NewName,
    [PSObject]$Location,
    [Switch]$MaintenanceMode = $true,
    [Switch]$DnsCheck
  )
 
  Process {
    if($DnsCheck){
      Try {
        [System.Net.Dns]::GetHostEntry($NewName).HostName | Out-Null
      }
      Catch {
        Write-Error "No DNS entry for $NewName"
        return
      }
    }
    $vCenterName = $global:DefaultVIServer.Name
     
    if($VMHost -is [System.String]){
      $VMHost = Get-VMHost -Name $VMHost
    }
    if($Location){
      if($Location -is [System.String]){
        $Location = Get-Inventory -Name $Location
      }
    }
    else {
      $Location = $VMHost.Parent
    }
    if($Location -isnot [VMware.VimAutomation.ViCore.Impl.V1.Inventory.ClusterImpl] -and
       $Location -isnot [VMware.VimAutomation.ViCore.Impl.V1.Inventory.DatacenterImpl]){
      Write-Error "Location $($Location.Name) must be a datacenter or a cluster"
      return
    }
     
    if($MaintenanceMode){
      $previousState = $VMHost.State
      Set-VMHost -VMHost $VMHost -State Maintenance | Out-Null
    }
    Set-VMHost -VMHost $VMHost -State Disconnected -Confirm:$false | 
    Remove-VMHost -Confirm:$false | Out-Null
 
    $esxServer = Connect-VIServer -Server $VMHost.Name -Credential $Credential
    $esxcli = Get-EsxCli -Server $esxServer
    $esxcli.system.hostname.set($null,$NewName,$null)
    Disconnect-VIServer -Server $esxServer -Confirm:$false
 
    Connect-VIServer -Server $vCenterName | Out-Null
    $VMHost = Add-VMHost -Name $NewName -Location $Location -Credential $Credential -Force -Confirm:$false
 
    if($MaintenanceMode){
      Set-VMHost -VMHost $VMHost -State $previousState -Confirm:$false | Out-Null
    }
  }
}