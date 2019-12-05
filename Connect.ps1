#$host.UI.RawUI.BackgroundColor = “DarkBlue”
#Clear-Host
$LiveCred = Get-Credential 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic –AllowRedirection 
Import-PSSession $Session -AllowClobber 
#Import-PSSession $Session –Prefix 365
connect-msolservice -credential $LiveCred 
#Remove-PSSession $Session