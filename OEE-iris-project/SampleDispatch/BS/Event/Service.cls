Class SampleDispatch.BS.Event.Service extends Ens.BusinessService {

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set sc = $$$OK
	
	#Dim oEvent As SampleDispatch.BO.Event.StatusChangeEvent
	
	try{
		set oEvent = ##class(SampleDispatch.BO.Event.StatusChangeEvent).%New()
		set oEvent.EquipmentId = pInput.Get("Eqmt")
		set oEvent.EventTime = pInput.Get("EventTime")
		set oEvent.NewStatusCode = pInput.Get("StatusCode")
		
		set sc = ..SendRequestAsync("Sample Dispatch Event Operation", oEvent)
		
	}Catch(oException){
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

Method OnInit() As %Status
{
   #; initialize persistent last key value
   Do ..Adapter.InitializePersistentValue(..%ConfigName,,0)
   Quit $$$OK
}

}