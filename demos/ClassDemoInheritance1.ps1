Class IB_ReferenceObject {
    #properties
    [String]$_ref
    #methods
    hidden [String] Delete(
       	[String]$Gridmaster,
		[Object]$Session,
		[String]$WapiVersion
    ){
        $URIString = "https://$Gridmaster/wapi/$WapiVersion/$($this._ref)"
        $return = Invoke-RestMethod -Uri $URIString -Method Delete -WebSession $Session
        return $return
    }
    #constructors
    IB_ReferenceObject(){}
    IB_ReferenceObject(
		[String]$_ref
	){
		$this._ref = $_ref
	}
}
