Function Get-SCCMClientPushFireWallSettings {

<#
.SYNOPSIS
    Will return the different firewall rules and their respective status needed for SCCM ClientPush deployment.

.DESCRIPTION
    This function can query either locally or remotly the status of the Firewall rules needed to be enabled for SCCM clientpush deployment.
    If need, it can also enable the missing firewall rules using -CorrectWMIRules or -CorrectFileRules
    By default, a very basic list ist sent back. 
    
    ComputerName Reachable WMIRules FileRules
    ------------ --------- -------- ---------
    db01              True     True      True
    cl01             False      N/A       N/A
    dc01              True     True      True

    For a detailed list, use -DetailedList.

    The computers are pinged prior to any task. It is reachable, then Reachable is set to true. If not, it is set to false, and WMIRules and FileRules to "N/A"

    WMIRules --> The WMIRules are all the Windows Firewall rules that are part of the 'Windows Management Instrumentation' group.
    FileRules -->The FileRules are all the Windows Firewall rules that are part of the 'File and Printer Sharing' group.

.PARAMETER ComputerName
	input a single computername,or an array of computers.
 
.PARAMETER DetailedList
    Will correct the File that are missing on each one of the computers specified in the ComputerName parameter.

.PARAMETER CorrectWMIRules
    Will correct the WMIRules that are missing on each one of the computers specified in the ComputerName parameter.

.PARAMETER CorrectFileRules
    Will correct the File that are missing on each one of the computers specified in the ComputerName parameter.

.EXAMPLE

Get-SCCMClientPushFireWallSettings

Returns an objet with the ComputerName, if it is reachable, the state of the WMIRules, and the state of the FileRules.
False means that some rules are missing to have a successfull SCCM client push.

WARNING: [CM01]Some WMI firewall rules are missing and should be enabled.
WARNING: [CM01]Use -detailedList to see the complete list. Use -CorrectFileRules to make the machine ready for ClientPush deployment.

ComputerName Reachable WMIRules FileRules
------------ --------- -------- ---------
CM01              True    False      True

.EXAMPLE

Get-SCCMClientPushFireWallSettings -CorrectWMIRules

This will correct all the missing WMI Firewall rules that are need for a successfull ConfigMgr Client push.

.EXAMPLE

Get-SCCMClientPushFireWallSettings -ComputerName db01,cl01,dc01 | Format-Table -AutoSize

This will query machines DB01,DC01 and CL01 for the different firewall settings. It will return the following table:

ComputerName Reachable WMIRules FileRules
------------ --------- -------- ---------
db01              True     True      True
cl01             False      N/A       N/A
dc01              True     True      True

(CL01 has is in this case not connected to the network, thus not reachable).
 
(Formating the output using Format-output is optional)

.EXAMPLE

"dc01","db01" | Get-SCCMClientPushFireWallSettings

This command will return the current state of each machine that has been piped into the function.

ComputerName Reachable WMIRules FileRules
------------ --------- -------- ---------
db01              True     True      True
dc01              True     True      True


.EXAMPLE

Get-SCCMClientPushFireWallSettings -DetailedList

This will return the complete list of firewall rules, no matter if they are currently enabled or not.

.EXAMPLE

The following command list all the firewall rules, and display only the Computername, Displayname (The firewall rule name) The displayGroup (Firewall group name) and if it is enabled or not.

Get-SCCMClientPushFireWallSettings -DetailedList | select pscomputername, displayname,displaygroup,enabled | Format-Table -AutoSize

WARNING: [CM01]Some WMI firewall rules are missing and should be enabled.
WARNING: [CM01]Use -detailedList to see the complete list. Use -CorrectWMIRules to make the machine ready for ClientPush deployment.


PSComputerName DisplayName                                            displaygroup                             Enabled
-------------- -----------                                            ------------                             -------
CM01           Windows Management Instrumentation (DCOM-In)           Windows Management Instrumentation (WMI)    True
CM01           Windows Management Instrumentation (WMI-In)            Windows Management Instrumentation (WMI)    True
CM01           Windows Management Instrumentation (WMI-Out)           Windows Management Instrumentation (WMI)   False
CM01           Windows Management Instrumentation (ASync-In)          Windows Management Instrumentation (WMI)    True
CM01           File and Printer Sharing (NB-Session-In)               File and Printer Sharing                    True
CM01           File and Printer Sharing (NB-Session-Out)              File and Printer Sharing                    True
CM01           File and Printer Sharing (SMB-In)                      File and Printer Sharing                    True
CM01           File and Printer Sharing (SMB-Out)                     File and Printer Sharing                    True
CM01           File and Printer Sharing (NB-Name-In)                  File and Printer Sharing                    True
CM01           File and Printer Sharing (NB-Name-Out)                 File and Printer Sharing                    True
CM01           File and Printer Sharing (NB-Datagram-In)              File and Printer Sharing                    True
CM01           File and Printer Sharing (NB-Datagram-Out)             File and Printer Sharing                    True
CM01           File and Printer Sharing (Spooler Service - RPC)       File and Printer Sharing                    True
CM01           File and Printer Sharing (Spooler Service - RPC-EPMAP) File and Printer Sharing                    True
CM01           File and Printer Sharing (Echo Request - ICMPv4-In)    File and Printer Sharing                    True
CM01           File and Printer Sharing (Echo Request - ICMPv4-Out)   File and Printer Sharing                    True
CM01           File and Printer Sharing (Echo Request - ICMPv6-In)    File and Printer Sharing                    True
CM01           File and Printer Sharing (Echo Request - ICMPv6-Out)   File and Printer Sharing                    True
CM01           File and Printer Sharing (LLMNR-UDP-In)                File and Printer Sharing                    True
CM01           File and Printer Sharing (LLMNR-UDP-Out)               File and Printer Sharing                    True
CM01           File and Printer Sharing (LLMNR-UDP-Out)               File and Printer Sharing                    True
CM01           File and Printer Sharing (Echo Request - ICMPv6-Out)   File and Printer Sharing                    True
CM01           File and Printer Sharing (Echo Request - ICMPv4-Out)   File and Printer Sharing                    True
CM01           File and Printer Sharing (NB-Datagram-Out)             File and Printer Sharing                    True
CM01           File and Printer Sharing (NB-Name-Out)                 File and Printer Sharing                    True
CM01           File and Printer Sharing (SMB-Out)                     File and Printer Sharing                    True
CM01           File and Printer Sharing (NB-Session-Out)              File and Printer Sharing                    True


.NOTES
    -Version: 1.0
	-Author: Stéphane van Gulick 
	-CreationDate: 12/04/2015
	-LastModifiedDate: 12/04/2015
	-History:
		12/04/2015: Creation and published on Technet : SVG

 .LINK
http://www.powerShellDistrict.com

 
 .LINK
https://social.technet.microsoft.com/profile/st%C3%A9phane%20vg/
    
	
#>


[cmdletBinding()]
Param(
    [Parameter(Mandatory=$false,ValueFromPipeline=$true)]
    [alias("CN","MachineName")]
    [string[]]$ComputerName = $env:COMPUTERNAME,
    [Parameter(Mandatory=$false)][switch]$CorrectWMIRules,
    [Parameter(Mandatory=$false)][switch]$CorrectFileRules,
    [Parameter(Mandatory=$false)][switch]$DetailedList,
    [Parameter(Mandatory=$false)]$Credentials
)



begin{

function Test-PsRemoting 
{
<#
Author Lee holmes: http://www.leeholmes.com/blog/2009/11/20/testing-for-powershell-remoting-test-psremoting/
#> 
    param( 
        [Parameter(Mandatory = $true)] 
        $computername 
    ) 
    
    try 
    { 
        $errorActionPreference = "Stop" 
        $result = Invoke-Command -ComputerName $computername { 1 } 
    } 
    catch 
    { 
        Write-Verbose $_ 
        return $false 
    } 
    
    ## I’ve never seen this happen, but if you want to be 
    ## thorough…. 
    if($result -ne 1) 
    { 
        Write-Verbose "Remoting to $computerName returned an unexpected result." 
        return $false 
    } 
    
    $true    
}
    $AllRules = @()
    $HighLevelReport = @()

          
         
}#EndBegin   
Process{

    foreach ($Comp in $ComputerName){
        Write-Verbose "Working on computer $($comp)"
        $Object =[pscustomobject]@{ComputerName=$Comp;Reachable=""; WMIRules="";FileRules=""}

        #It could happen that firewall actually blocks ping, but that PS remoting is enabled. Test-Connection is then not realiable in this case.
        #Test-Connection -computerName $Comp -Quiet -Count 1
        if (Test-PsRemoting -computername $comp){                                                                                                                                                                                                                                                   
            $Object.reachable = $true
            if ($DetailedList){
                $WMIRules = Get-NetFirewallRule -CimSession $Comp | Where-Object {($_.DisplayGroup -like 'Windows Management Instrumentation*') -and ($_.Profile -eq "domain")}
                $FileRules = Get-NetFirewallRule -CimSession $Comp | Where-Object {($_.DisplayGroup -like 'File and Printer Sharing') -and ($_.Profile -eq "domain")}
            }
            else{
                $WMIRules = Get-NetFirewallRule -CimSession $Comp -Enabled False| Where-Object {($_.DisplayGroup -like 'Windows Management Instrumentation*') -and ($_.Profile -eq "domain")}
                $FileRules = Get-NetFirewallRule -CimSession $Comp -Enabled False | Where-Object {($_.DisplayGroup -like 'File and Printer Sharing') -and ($_.Profile -eq "domain")}
            }#DetailedList
            

            if ($WMIRules){
                        Write-Warning "[$($Comp)]Some WMI firewall rules are missing and should be enabled."
                        Write-Warning "[$($Comp)]Use -detailedList to see the complete list. Use -CorrectWMIRules to make the machine ready for ClientPush deployment."
                        $Object.wmiRules = $false
                        
            }
            else{
            
                write-verbose "[$($Comp)]All WMI firewall rules are correctly set."
                $Object.wmiRules = $true
            }#End WMIRules

            if ($FileRules){
                        Write-Warning "[$($Comp)]Some File firewall rules are missing and should be enabled."
                        Write-Warning "[$($Comp)]Use -detailedList to see the complete list. Use -CorrectFileRules to make the machine ready for ClientPush deployment."
                        $Object.fileRules = $false
                        
            }
            else{
                write-verbose "[$($Comp)]All File rules firewall are correctly set."
                $Object.fileRules = $true
            }


            if ($CorrectWMIRules){
                write-verbose "[$($Comp)]Correcting WMI missing rules."
        
                    #$WMIRules = Get-NetFirewallRule -CimSession $Comp | Where-Object {$_.DisplayGroup -like 'Windows Management Instrumentation*'}
  
                foreach ($WMIRule in $WMIRules){
                    if ($WMIRule.Enabled -eq 'false'){
                        Write-Verbose  "[$($Comp)]Enabeling $($WMIRule.DisplayName)"
                        try{
                            $WMIRule | Set-NetFirewallRule -Enabled true -ErrorAction Stop
                            }
                        catch{
                            write-warning "$_"
                        }
                        
                    }#endif
                }#end foreach
                write-host 'Enabled WMI Firewall Rules' -ForegroundColor green
                $Object.WMIRules = $true
            }#End if Correct WMIRules

            if ($CorrectFileRules){
                write-verbose "[$($Comp)]Correcting File missing rules."


                foreach ($FileRule in $FileRules){
                    if ($FileRule.Enabled -eq 'false'){
                        Write-Verbose  "[$($Comp)]Enabeling $($FileRule.DisplayName)"
                        try{
                            $FileRule | Set-NetFirewallRule -Enabled true -ErrorAction Stop
                            }
                        catch{
                            write-warning "$_"
                        }
                    }#Endif
                }#endforeach
                
                $Object.fileRules = $true
                write-host 'Enabled File and print Firewall Rules' -ForegroundColor green
            }#endifCorrectFileRules
       
            if ($detailedList){
                foreach ($rw in $WMIRules){
                    $AllRules += $rw
                }
                foreach ($rf in $FileRules){
                    $AllRules += $rf
                }
            }#endifdetailedlist

        $HighLevelReport += $Object
         
    
        }else{

                $Object.reachable = $false
                $Object.WMIRules = "N/A"
                $Object.fileRules = "N/A"
                $HighLevelReport += $Object
                Write-verbose "Coulnd't reach computer $($Comp)."
                continue
            
            }#end Test connection
    }#EndForeach

}#End Process
end{

        if ($detailedList){
            write-verbose "Returning detailed Firewall configuration list"
            return $AllRules
        }else{
             return $HighLevelReport
        }

           
    }#end end ;)

}