$Users = Get-Content "C:\1\Scratch\Users\1.txt" 


$Groups = "SG-WebFTP-Users"

ForEach ($Group in $Groups)
{   Add-ADGroupMember -Identity $Group -Members $Users -Verbose
}