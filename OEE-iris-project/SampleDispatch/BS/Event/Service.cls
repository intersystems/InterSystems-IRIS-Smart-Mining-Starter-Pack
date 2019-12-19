Include DEMOMACROS

Class SampleDispatch.BS.Event.Service extends Ens.BusinessService {

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Property Adapter As EnsLib.SQL.InboundAdapter;

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set sc = $$$OK
	
	#Dim oEvent As SampleDispatch.BO.Event.StatusChangeEvent
	
	try 
	{
		Do ..ProcessEvents()
		
		//Do ..ProcessDumps()
		
	}
	Catch(oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

Method ProcessEvents()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastEventKey")
	
	Set tQueryStatement="SELECT ID, Code->Code StatusCode, Eqmt, ""Time"" EventTime "_
						"FROM SampleDispatch.Events where ID>?"
						
	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	$$$ThrowStatusExceptionIfError(sc, "ProcessEventsQueryException")
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("ID")
		$$$TRACE("Processing State Change Event "_tLastKey_"...")
		
		set oEvent = ##class(SampleDispatch.BO.Event.StatusChangeEvent).%New()
		set oEvent.EquipmentId = oRS.Get("Eqmt")
		set oEvent.EventTime = oRS.Get("EventTime")
		set oEvent.NewStatusCode = oRS.Get("StatusCode")
		
		Set ..%SessionId=""
		
		set sc = ..SendRequestAsync("Sample Dispatch Event Operation", oEvent)
		$$$ThrowStatusExceptionIfError(sc, "ProcessSingleEventException")
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastEventKey", tLastKey)
	}	
}

Method ProcessDumps()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastDumpKey")
	
	Set tQueryStatement="SELECT ID, Eqmt, ""Time"" EventTime, Tons "_
						"FROM SampleDispatch.Dumps where ID>?"
						
	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	$$$ThrowStatusExceptionIfError(sc, "ProcessDumpsQueryException")
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("ID")
		$$$TRACE("Processing Dump "_tLastKey_"...")
		
		set oEvent = ##class(SampleDispatch.BO.Event.DumpEvent).%New()
		set oEvent.EquipmentId = oRS.Get("Eqmt")
		set oEvent.EventTime = oRS.Get("EventTime")
		set oEvent.Tons = oRS.Get("Tons")
		
		Set ..%SessionId=""
		
		set sc = ..SendRequestAsync("Sample Dispatch Event Operation", oEvent)
		$$$ThrowStatusExceptionIfError(sc, "ProcessSingleDumpException")
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastDumpKey", tLastKey)
	}
	
	
}

Method OnInit() As %Status
{
   #; initialize persistent last key value
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey",0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastDumpKey",0)
   Quit $$$OK
}

}