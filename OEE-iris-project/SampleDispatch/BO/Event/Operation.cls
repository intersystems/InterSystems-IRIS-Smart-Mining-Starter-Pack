Class SampleDispatch.BO.Event.Operation extends Ens.BusinessOperation {

Parameter INVOCATION = "Queue";

Method StatusChangeEvent(pInput As SampleDispatch.BO.Event.StatusChangeEvent, Output pOutput As Ens.Response) As %Status
{
	#Dim eventChange As OEE.Data.EventChange
	
	Set sc=$$$OK
	
	Try
	{
		Set eventChange = ##class(OEE.Data.EventChange).%New()
		Set eventChange.EquimentId = pInput.EquimentId
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