#Get users from CSV location in C:\1\adgroups.csv – NO sunbeam\ prefix
$users = Get-Content C:\1\adgroups.csv

#Declare new variable ($user) from each line in ($users)
Foreach ($user in $users)

#Identity group name after –Identity , Identitify users you’d like to add by using variable ($user)
{
Add-ADGroupMember -Identity "QlikViewUAG" -Members $user -Verbose
} 
