$Source_Group = "JAHG-Common1" 
$Destination_Group = "josetestgroup030216"  
$Target = Get-ADGroupMember -Identity $Source_Group

ForEach ($Person in $Target) 
{ 
    Add-ADGroupMember -Identity $Destination_Group -Members $Person -Verbose
    }