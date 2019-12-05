PARAM(

$Alias="VillarN"

)

 

# Assign the Drive letter and Home Drive for

# the user in Active Directory

 

$HomeDrive=’S:’

$Accountname="$Alias"

$UserRoot="\\bocfl-sbfs01.sunbeamproducts.sunbeam.com\users$\"

$HomeDirectory=$UserRoot+$AccountName 

$map="\\bocfl-sbfs01\$Alias$"

SET-ADUSER $Alias –HomeDrive $HomeDrive –HomeDirectory "$map" 

 

# Create the folder on the root of the common Users Share

 

NEW-ITEM –path $HomeDirectory -type directory -force 

$Domain="sunbeamproducts.sunbeam.com"

$IdentityReference=$Domain+’’+$Accountname

 

# Set parameters for Access rule

 

$FileSystemAccessRights=[System.Security.AccessControl.FileSystemRights]”FullControl”

$InheritanceFlags=[System.Security.AccessControl.InheritanceFlags]”ContainerInherit, ObjectInherit”

$PropagationFlags=[System.Security.AccessControl.PropagationFlags]”None”

$AccessControl=[System.Security.AccessControl.AccessControlType]”Allow”

 

# Build Access Rule from parameters

$AccessRule=New-Object System.Security.AccessControl.FileSystemAccessRule @($alias,"Modify","ObjectInherit, ContainerInherit","None","Allow")

# Get current Access Rule from Home Folder for User

$HomeFolderACL=GET-ACL $HomeDirectory

$HomeFolderACL.AddAccessRule($AccessRule)

SET-ACL –path $HomeDirectory -AclObject $HomeFolderACL