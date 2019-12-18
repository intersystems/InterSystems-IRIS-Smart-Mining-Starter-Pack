Class SampleDispatch.BS.Event.Service extends Ens.BusinessService {

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Property Adapter As EnsLib.SQL.InboundAdapter;

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	#Dim oEvent As SampleDispatch.BO.Event.StatusChangeEvent
	
	Set sc=$$$OK
	
	Try
	{		
	
		Set sc = ..Adapter
		Set oEvent = ##class(SampleDispatch.BO.Event.StatusChangeEvent).%New()
		Set oEvent.EquimentId = pInput.Get("Eqmt")
		Set oEvent.EventTime = pInput.Get("EventTime")
		Set oEvent.NewStatusCode = pInput.Get("StatusCode")
		
		Set sc = ..SendRequestAsync("Sample Dispatch Event Operation", oEvent)
	}
	Catch (oException)
	{
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