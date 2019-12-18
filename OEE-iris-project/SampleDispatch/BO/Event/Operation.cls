Class SampleDispatch.BO.Event.Operation extends Ens.BusinessOperation {

Parameter INVOCATION = "Queue";

Method StatusChangeEvent(pInput As SampleDispatch.BO.Event.StatusChangeEvent, Output pOutput As Ens.Response) As %Status
{	
	Set sc = $$$OK
	
	#Dim eventChange as OEE.Data.EventChange
	try{
	
		set eventChange = ##class(OEE.Data.EventChange).%New()
		set eventChange.EquipmentId = pInput.EquipmentId
		set eventChange.NewStatusCode = pInput.NewStatusCode
		set eventChange.StartTime = pInput.EventTime
		
		set sc = eventChange.%Save()
		
	}Catch(oException){
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

XData MessageMap {
<MapItems>
    <MapItem MessageType="SampleDispatch.BO.Event.StatusChangeEvent">
        <Method>StatusChangeEvent</Method>
    </MapItem>
</MapItems>
}

}