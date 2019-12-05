$path = "$envUserMyDocuments\test.txt"

if(!(Test-Path -Path $path))
  {
   new-item -Path $path -Value "new file" –itemtype file
  }
else
  {
   Show-DialogBox -Title 'File Exsists' -Text 'File already exists!' -Icon 'Information' 
  }
 