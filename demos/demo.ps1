remove-module infobloxcmdlets
Set-Location c:\repos\PSSummit2018\demos
. .\demohelperfunctions.ps1
Get-ChildItem cmdlet*.ps1 | ForEach-Object{. $_.fullname}
$gridmaster = 'ib-gridmaster.southcentralus.cloudapp.azure.com'
$credential = get-credential
New-IBWebSession -gridmaster $Gridmaster -Credential $credential

. .\classdemo1.ps1

#authentication
$IBSession
$IBGridmaster
$IBWapiVersion

#show static overloads
[ib_dnsarecord]::get
[ib_dnsarecord]::Create

$Record = [ib_dnsarecord]::get($Gridmaster, $IBSession, $IBWapiVersion, 'server1', $Null, $Null, $Null, $Null, $Null, $Null, 1)
$record
$Record | get-member

#show set and delete overloads
$record[0].delete
$record[0].set

#inheritance
. .\ClassDemoInheritance2.ps1
. .\ClassDemo2.ps1

$Record2 = [ib_dnsarecord]::get($Gridmaster, $IBSession, $IBWapiVersion, 'server1', $Null, $Null, $Null, $Null, $Null, $Null, 1)
$RefRecord = [ib_ReferenceObject]::get($Gridmaster, $IBSession, $IBWapiVersion, $($Record2._ref))

$RefRecord
$RefRecord | get-member

$record2
$record2[0].ToString()
$record[0].ToString()

#cmdlets
Get-IBDNSARecord -Name Server1
get-ibdnsarecord -name server1 -comment 'the other one'

New-IBDNSARecord -name server3.domain.com -comment 'newrecord' -IPAddress 10.0.0.3

Get-ibdnsarecord -name server1 | Remove-IBDNSARecord
get-ibdnsarecord -name server2 | Set-IBDNSARecord -Comment 'updated comment'

