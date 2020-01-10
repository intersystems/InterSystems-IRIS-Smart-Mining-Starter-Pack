Class SampleDispatch.BS.Event.MineCareService Extends Ens.BusinessService
{
/// We are using this custom adapter that is based on EnsLib.SQL.InboundAdapter to hide some properties we don't
/// want people to change.
Parameter ADAPTER = "SampleDispatch.Adapter.SQL.PeriodicInboundAdapterMC";

Property Adapter As SampleDispatch.Adapter.SQL.PeriodicInboundAdapterMC;

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set sc = $$$OK
	
	#Dim oEvent As SampleDispatch.BO.Event.StatusChangeEvent
	
	try 
	{		
		Do ..ProcessCompletedDumps()
		
	}
	Catch(oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

/// We will only bring dumps that are COMPLETE. So we are querying for all NEW dumps that have a non null EndTime
Method ProcessCompletedDumps()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastCompletedDumpKey")
	
	Set tQueryStatement="SELECT TOP 1 * from dbo.Activity"
						
	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("Id")
		$$$TRACE("Processing Dump "_tLastKey_"...")
		
		set oEvent = ##class(SampleDispatch.BO.Event.CompletedDumpEvent).%New()
		set oEvent.EquipmentId = oRS.Get("EquipmentId")
		set oEvent.StartTime = oRS.Get("StartTime")
		set oEvent.EndTime = oRS.Get("EndTime")
		set oEvent.Tons = oRS.Get("SiteId")
		
		Set ..%SessionId=""
		
		set sc = ..SendRequestAsync("Sample Dispatch Event Operation", oEvent)
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastCompletedDumpKey", tLastKey)
	}
	
	
}

Method OnInit() As %Status
{
   #; initialize persistent last key value
   //Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey",0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey", $ZDateTime("0,0", 3))
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastCompletedDumpKey",0)
   Quit $$$OK
}

}