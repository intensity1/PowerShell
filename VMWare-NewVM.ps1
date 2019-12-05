new-VM -Name CTXRDTGLZDR14 `
              -Template 'Template-Roadnet 0827' `
              -VMHost "flmir-esxdq1.sgws.com" `
              -Datastore "san-flmir-devqa02" `
              -OSCustomizationSpec "Clone of Windows"`
