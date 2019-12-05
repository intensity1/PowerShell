$usernames = get-content C:\1\dockpc.csv
$password = "{YXjmFyzB,]3jgK3" | ConvertTo-SecureString -AsPlainText -Force

Foreach ($username in $usernames)

{
New-ADUser $username -AccountPassword $password -Path "OU=Users-Win7,OU=Fontana,DC=sunbeamproducts,DC=sunbeam,DC=com"  -Verbose
}