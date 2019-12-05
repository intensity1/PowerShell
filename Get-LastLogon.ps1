$mb = Get-Mailbox -ResultSize Unlimited
$file = "C:\1\365mb-$((get-date).tostring("MM-dd")).csv"
$i=0

If (Test-Path $file){
	Remove-Item $file
}

foreach($m in $mb)
{
  $i++
  Write-Progress -Activity "Getting Last Logons..." -Status "Status: " -CurrentOperation $m.DisplayName -PercentComplete (($i / $mb.count) * 100)
  Start-Sleep -Milliseconds 200
  
  $mbstat = Get-MailboxStatistics $m.DistinguishedName | select DisplayName,`
  @{label="UPN";expression={$m.UserPrincipalName}},`
  TotalItemSize,TotalDeletedItemSize,ItemCount,LastLogonTime,`
  @{label="RetentionPolicy";expression={$m.RetentionPolicy}},`
  @{label="CustomAttribute15";expression={$m.CustomAttribute15}},`
  @{label="IsShared";expression={$m.isshared}},`
  @{label="WhenCreated";expression={$m.whencreated}},`
  @{label="AccountEnabled";expression={(Get-ADUser -Filter "UserPrincipalName -eq '$($m.UserPrincipalName)'" -Server swsad1.swsad.com:3268).Enabled}},`
  @{label="EmployeeID";expression={(Get-ADUser -Filter "UserPrincipalName -eq '$($m.UserPrincipalName)'" -Server swsad1.swsad.com:3268 -Properties EmployeeID).EmployeeID}},`
  @{label="isLicensed";expression={(Get-MsolUser -UserPrincipalName $m.UserPrincipalName).isLicensed}},`
  @{label="Licenses";expression={(Get-MsolUser -UserPrincipalName $m.UserPrincipalName).Licenses.AccountSkuId}}

  $mbstat | Export-Csv $file -Encoding ASCII -notype -append
}

Write-Host "Output to $file"