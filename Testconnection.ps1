$Computers = Get-Content C:\1\Scratch\IPs.csv
foreach ($computer in $Computers)
{
Test-Connection $Computer -Count 1 -ErrorAction Continue| ft -AutoSize #| Export-Csv C:\1\Scratch\sccmdpresult.csv -Append
}