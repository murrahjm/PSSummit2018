add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$IBCred = new-object -TypeName PSCredential -ArgumentList 'admin', $('Password1234' | convertto-securestring -AsPlainText -force)
$gridmastername = 'ib-gridmasterdemo'
$location = 'westus'
Login-AzureRmAccount -subscriptionName "MSDN Platforms"
New-AzureRMResourceGroup -name 'PSSummit-Infoblox' -Location $location
New-AzureRmResourceGroupDeployment -ResourceGroupName 'PSSummit-Infoblox' -TemplateFile ".\AzureDeploy.json" -virtualMachines_TestGridmaster_adminPassword 'Password1234' -location 'westus'
New-IBWebSession -Gridmaster "$gridmastername`.$location`.cloudapp.azure.com" -Credential $IBCred

New-ibdnszone -fqdn domain.com -confirm:$False
New-ibdnsarecord -Name Server1.domain.com -IPAddress 10.0.0.1 -confirm:$False
New-IBDNSARecord -name server1.domain.com -comment 'the other one' -IPAddress 10.0.0.10 -confirm:$False
New-IBDNSARecord -Name Server2.domain.com -Comment 'second record' -IPAddress 10.0.0.2 -confirm:$False