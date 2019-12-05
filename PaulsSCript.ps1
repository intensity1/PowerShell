#AD Groups that will receive new members and get cleaned up
$adGroups = "SCCM - Servers - DEV Group - 2TUE10PM", "SCCM - Servers - QA UAT - 2FRI10PM"

#RegEx used to find DEV, QA, and UAT servers
$regEx = ".*DV[0-9]", ".*(QA|UA)[0-9]"

#Array to store computer objects
$list = New-Object System.Collections.ArrayList

#Iterate through each RegEx
[bool]$match = $false
For($i = 0; $i -le $regEx.Count - 1; $i++) {
    Write-Host $regEx[$i] - $i
    $list.Clear()
    Write-Host List Cleared!
    #Get list of computer accounts for current RegEx
    $computers = (Get-ADComputer -Server SWSAD1:3268 -Filter {Enabled -eq $True} | ? {$_.Name -match "$($regEx[$i])"} | Select Name,DNSHostName,DistinguishedName)

    #Get attributes for each computer object with a ***Server OS*** in $computers
    ForEach ($computer in $computers) {
        If ((Get-ADComputer ($computer.DNSHostName -split "\.", 2)[0] -Server ($computer.DNSHostname -split "\.", 2)[1] -Properties OperatingSystem | Select OperatingSystem) -like "*server*") {
            $list.Add($computer) > $null
        }
    }

    #Check each group to see if the server account already exists in the group
    $list             
    #Iterate through each computer in the list
    ForEach ($computer in $list) {
        
        $members = (Get-ADGroupMember $adGroups[$i])
        If ( $members.Count -eq 0 ) {
            break
        }
        #Iterate through each member of the current group
        ForEach ($member in $members) {
                
            $currentHost = ($computer.DNSHostName -split "\.", 2)[0]
                
            #If current host AND group are DEV, *OR* current host AND group are QA/UAT
            If ( (($currentHost -match $regEx[$i]) -and ($adGroups[$i] -match ".*DEV.*")) -or `
                (($currentHost -match $regEx[$i]) -and ($adGroups[$i] -match ".*(QA|UA)")) ) {
                    
                #If computer is already a member then break
                If ( $computer.DistinguishedName -eq $member.DistinguishedName ) {
                    Write-Host Already a member 
                    $match = $true
                    break
                } 
            }
        }

        If ($match -eq $false) {
            Write-Host RegEx: $regEx[$i]`tGroup: $adGroups[$i]`tHost: $currentHost`tMember: $member
        } else {
            $match = $false
        }
    }
} 

