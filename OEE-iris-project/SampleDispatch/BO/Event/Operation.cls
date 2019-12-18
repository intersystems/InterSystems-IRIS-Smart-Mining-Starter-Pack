Class SampleDispatch.BO.Event.Operation extends Ens.BusinessOperation {

Parameter INVOCATION = "Queue";

Method StatusChangeEvent(pInput As SampleDispatch.BO.Event.StatusChangeEvent, Output pOutput As Ens.Response) As %Status
{
	#Dim eventChange As OEE.Data.EventChange
	#Dim previousChange As OEE.Data.EventChange
	Set sc=$$$OK
	
	Try
	{
		Set previousChange = ##class(OEE.Data.EventChange).GetLastEventChangeForEquipment(pInput.EquipmentId)
		
		If previousChange'=""
		{
			Set previousChange.EndTime = pInput.EventTime
			Set sc = previousChange.%Save()
			Quit:$$$ISERR(sc)
		}
		
		Set eventChange = ##class(OEE.Data.EventChange).%New()
		Set eventChange.EquipmentId = pInput.EquipmentId
		Set eventChange.NewStatusCode = pInput.NewStatusCode
		Set eventChange.StartTime = pInput.EventTime
		
		Set sc = eventChange.%Save()
		
	}
	Catch (oException)
	{
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