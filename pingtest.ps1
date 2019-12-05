$ping = New-Object System.Net.NetworkInformation.Ping
$servers = Get-Content C:\1\CSVs\1.txt

foreach ($server in $servers)
{
$ping.Send($server) | ft -Property address,Status | Out-File C:\1\CSVs\results.csv -Append
}