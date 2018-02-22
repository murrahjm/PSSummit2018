Function New-IBDNSARecord {
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact="High")]
    Param(
        [Parameter(Mandatory=$False)]
        [ValidateScript({If($_){Test-IBGridmaster $_ -quiet}})]
        [String]$Gridmaster,

        [Parameter(Mandatory=$False)]
		[System.Management.Automation.PSCredential]
		[System.Management.Automation.Credential()]
		$Credential,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [IPAddress]$IPAddress,

        [String]$View,

        [String]$Comment,

        [uint32]$TTL = 4294967295

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
        If ($ttl -eq 4294967295){
            $use_ttl = $False
            $ttl = $Null
        } else {
            $use_TTL = $True
        }
        If ($pscmdlet.ShouldProcess($Name)){
            $output = [IB_DNSARecord]::Create($Script:IBGridmaster,$Script:IBSession,$Script:IBWapiVersion,$Name, $IPAddress, $Comment, $View, $ttl, $use_ttl)
            $output
        }
    }
    END{}
}
