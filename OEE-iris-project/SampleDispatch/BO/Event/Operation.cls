Class SampleDispatch.BO.Event.Operation extends Ens.BusinessOperation {

Parameter INVOCATION = "Queue";

Method StatusChangeEvent(pInput As SampleDispatch.BO.Event.StatusChangeEvent, Output pOutput As Ens.Response) As %Status
{
	Set sc=$$$OK
	
	Try
	{
		//TODO:
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