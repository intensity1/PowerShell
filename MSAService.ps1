New-ADServiceAccount -Description "SQL SSAS MSA for qippsqlp01"`
-DisplayName sqlsasqippp01 `
-DNSHostName sqlsasqippp01.sgws.com `
-Name sqlsasqippp01 `
-PrincipalsAllowedToRetrieveManagedPassword qippsqlp01$ `
-Path "OU=ServiceAccounts,OU=SQL,OU=SGWS Infrastructure,DC=sgws,DC=com" `
-Verbose

#RUN THE INSTALL ON SERVERS!
#Install-ADServiceAccount -Identity sqlagtqippp01
#qippsqlp01 