Class SampleDispatch.BS.Event.MineCareService Extends Ens.BusinessService
{
/// We are using this custom adapter that is based on EnsLib.SQL.InboundAdapter to hide some properties we don't
/// want people to change.
Parameter ADAPTER = "SampleDispatch.Adapter.SQL.PeriodicInboundAdapterMC";

Property Adapter As SampleDispatch.Adapter.SQL.PeriodicInboundAdapterMC;

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set sc = $$$OK
	
	#Dim oEvent As SampleDispatch.BO.Event.CompleteEvent
	
	try 
	{		
		Do ..ProcessOEMEvent()
		
	}
	Catch(oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

/// We will only bring dumps that are COMPLETE. So we are querying for all NEW dumps that have a non null EndTime
Method ProcessOEMEvent()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastOEMEventKey")
	$$$TRACE("Next OEM event Id "_tLastKey_"...")
	
	/// Gets all the new received events
	Set tQueryStatement="SELECT Id, EquipmentId, OemEventTypeId, ReadTime, FloatValue FROM dbo.OemEventValue WHERE Id>?"
						
						
	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("Id")
		$$$TRACE("Processing OEM event Id "_tLastKey_"...")
		
		#Dim oEvent as ASPMining.CanonicalModel.HWMonitoring.OEMEvent
		/// oRS.Get Names must match SQL query var names
		set oEvent = ##class(ASPMining.CanonicalModel.HWMonitoring.OEMEvent).%New()
		//set oEvent.EquipmentId = oRS.Get("EquipmentId") //get the real equipment
		set oEvent.Id = oRS.Get("Id") //get the real equipment
		set readtime = oRS.Get("ReadTime")
		set oEvent.ReadTime = $ZDATETIMEH(readtime, 3) //,7
		
		Set ..%SessionId=""
		
		set sc = ..SendRequestAsync("PowerView Event Operation", oEvent)
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastOEMEventKey", tLastKey)
	}
	
	
}

Method OnInit() As %Status
{
   #; initialize persistent last key value
   //Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey",0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastOEMEventKey", 0)
   /// lAST eVENT KEY IS A TIMESTAMP KEY
   /// Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey", $ZDateTime("0,0", 3))
   /// Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastCompletedDumpKey",0)
   Quit $$$OK
}

}