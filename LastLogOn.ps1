$servers = Get-Content C:\1\CSVs\1.txt

foreach ($server in $servers)
{
Get-ADComputer -identity $server -Properties * -Server swsad1.swsad.com| select DNSHostName,LastLogonDate|Out-File C:\1\CSVs\results.csv -Append
}