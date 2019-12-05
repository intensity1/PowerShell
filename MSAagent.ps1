New-ADServiceAccount -Description "SQL Agent MSA for RNSQLGLZDV01"`
-DisplayName sqlagtrdtglzd01 `
-DNSHostName sqlagtrdtglzd01.sgws.com `
-Name sqlagtrdtglzd01 `
-PrincipalsAllowedToRetrieveManagedPassword SG-MSA-RDTGLZDV `
-Path "OU=ServiceAccounts,OU=Glazers Environment,OU=RoadNet,OU=SGWS Infrastructure,DC=sgws,DC=com"