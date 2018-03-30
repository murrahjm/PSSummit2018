Login-AzureRmAccount -subscriptionName "MSDN Platforms"
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
cd C:\repos\PSSummit2018\misc

$IBCred = new-object -TypeName PSCredential -ArgumentList 'admin', $('Password1234' | convertto-securestring -AsPlainText -force)
$gridmastername = 'ib-gridmasterdemo'
$location = 'southcentralus'
$RGName = 'PSSummit-Infoblox'
New-AzureRMResourceGroup -name $RGName -Location $location
New-AzureRmResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile ".\AzureDeploy.json" -virtualMachines_TestGridmaster_adminPassword 'Password1234' -location $location

New-IBWebSession -Gridmaster "$gridmastername`.$location`.cloudapp.azure.com" -Credential $IBCred

New-ibdnszone -fqdn domain.com -confirm:$False -Verbose
New-ibdnsarecord -Name Server1.domain.com -IPAddress 10.0.0.1 -confirm:$False
New-IBDNSARecord -name server1.domain.com -comment 'the other one' -IPAddress 10.0.0.10 -confirm:$False
New-IBDNSARecord -Name Server2.domain.com -Comment 'second record' -IPAddress 10.0.0.2 -confirm:$False


remove-module infobloxcmdlets
uninstall-module infobloxcmdlets
Set-Location c:\repos\PSSummit2018\demos
. .\demohelperfunctions.ps1
Get-ChildItem cmdlet*.ps1 | ForEach-Object{. $_.fullname}
