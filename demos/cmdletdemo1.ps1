Function Get-IBDNSARecord {
	[CmdletBinding(DefaultParameterSetName = 'byQuery')]
	Param(
        [Parameter(Mandatory=$False)]
        [ValidateScript({If($_){Test-IBGridmaster $_ -quiet}})]
        [String]$Gridmaster,

        [Parameter(Mandatory=$False)]
		[System.Management.Automation.PSCredential]
		[System.Management.Automation.Credential()]
		$Credential,

		[Parameter(ParameterSetName='byQuery')]
		[String]$Name,

		[Parameter(ParameterSetName='byQuery')]
		[IPAddress]$IPAddress,

		[Parameter(ParameterSetName='byQuery')]
		[String]$View,

		[Parameter(ParameterSetName='byQuery')]
		[String]$Zone,

		[Parameter(ParameterSetName='byQuery')]
		[String]$Comment,

		[Parameter(ParameterSetname='byQuery')]
		[String]$ExtAttributeQuery,
        
		[Parameter(ParameterSetName='byQuery')]
        [Switch]$Strict,

		[Parameter(Mandatory=$True,ValueFromPipeline=$True,ParameterSetName='byref')]
		[String]$_ref,

        [Int]$MaxResults
	)
    BEGIN{
        $FunctionName = $pscmdlet.MyInvocation.InvocationName.ToUpper()
        write-verbose "$FunctionName`:  Beginning Function"
		If (! $script:IBSession){
			write-verbose "Existing session to infoblox gridmaster does not exist."
			If ($gridmaster -and $Credential){
				write-verbose "Creating session to $gridmaster with user $($credential.username)"
				New-IBWebSession -gridmaster $Gridmaster -Credential $Credential -erroraction Stop  | out-null
			} else {
				write-error "Missing required parameters to connect to Gridmaster" -ea Stop
			}
		} else {
			write-verbose "Existing session to $script:IBgridmaster found"
        }
    }
	PROCESS{
		If ($pscmdlet.ParameterSetName -eq 'byQuery') {
			Write-Verbose "$FunctionName`:  Performing query search for A Records"
			[IB_DNSARecord]::Get($script:IBGridmaster,$script:IBSession,$script:IBWapiVersion,$Name,$IPAddress,$Comment,$ExtAttributeQuery,$Zone,$View,$Strict,$MaxResults)
		} else {
			Write-Verbose "$FunctionName`: Querying $script:IBgridmaster for A record with reference string $_ref"
			[IB_DNSARecord]::Get($script:IBGridmaster,$script:IBSession,$script:IBWapiVersion,$_ref)
		}
	}
	END{}
}