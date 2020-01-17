Include DEMOMACROS

Class SampleDispatch.BO.Event.Operation extends Ens.BusinessOperation {

Parameter INVOCATION = "Queue";

Method StatusChangeEvent(pInput As SampleDispatch.BO.Event.StatusChangeEvent, Output pOutput As Ens.Response) As %Status
{
	#Dim eventChange As OEE.Data.EventChange
	#Dim previousChange As OEE.Data.EventChange
	Set sc=$$$OK
	
	Try
	{
		Set previousChange = ##class(OEE.Data.EventChange).GetLastEventChangeForEquipment(pInput.EquipmentId, pInput.EventTime)
		
		If previousChange'=""
		{
			Set previousChange.EndTime = pInput.EventTime
			Set previousChange.SessionIds=previousChange.SessionIds_","_..%SessionId
			Set sc = previousChange.%Save()
			Quit:$$$ISERR(sc)
			
			// Now that we have an end time, we can fragment it.
			// Later, for 400 events (downtime), we will need to find the endtime using, maybe, the shift downtime
			// We would fix this later.
			Do ..FragmentChangeEvent(previousChange)
		}
		
		Set eventChange = ##class(OEE.Data.EventChange).%New()
		Set eventChange.EquipmentId = pInput.EquipmentId
		Set eventChange.NewStatusCode = pInput.NewStatusCode
		Set eventChange.StartTime = pInput.EventTime
		Set eventChange.SessionIds=eventChange.SessionIds_","_..%SessionId
		
		Set sc = eventChange.%Save()
		Quit:$$$ISERR(sc)		
		
	}
	Catch (oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

ClassMethod FragmentChangeEvent(pChangeEvent As OEE.Data.EventChange)
{
	// Now we can update the time slice record
	// FRAGMENTATION into Time Slice table
	
	Set tTimeSliceStartTime = pChangeEvent.StartTime
	Set tOriginalEndTime = pChangeEvent.EndTime
	
	Set bFinished=0
	Do 
	{
		// Adding one minute 
		Set tTimeSliceEndTime=$System.SQL.DATEADD("mi", 1, tTimeSliceStartTime)
		
		// Have I gone too far? I mean: Beyond my tOriginalEndTime?
		// Or am I right at it?
		If (tTimeSliceEndTime ]] tOriginalEndTime) || (tTimeSliceEndTime = tOriginalEndTime)
		{
			//Then that is my last end time and it should match my tOriginalEndTime
			Set tTimeSliceEndTime = tOriginalEndTime
			
			//That is my last one...
			Set bFinished = 1
		}
					
		Do ..CreateTimesliceChangeEvent(pChangeEvent, tTimeSliceStartTime, tTimeSliceEndTime)
		
		Set tTimeSliceStartTime=tTimeSliceEndTime
	}
	While 'bFinished
}

ClassMethod CreateTimesliceChangeEvent(pChangeEvent As OEE.Data.EventChange, pTimeSliceStartTime As %TimeStamp, pTimeSliceEndTime As %TimeStamp)
{
	#Dim timesliceChangeEvent As OEE.Data.OEETimeSlice
	
	Set timesliceChangeEvent = ##class(OEE.Data.OEETimeSlice).%New()
	Set timesliceChangeEvent.EventChange = pChangeEvent
	Set timesliceChangeEvent.StartTime = pTimeSliceStartTime
	Set timesliceChangeEvent.EndTime = pTimeSliceEndTime
	
	Set sc = timesliceChangeEvent.%Save()
	$$$ThrowStatusExceptionIfError(sc, "FragmentChangeEventException")
	
}

Method CompletedDumpEvent(pInput As SampleDispatch.BO.Event.CompletedDumpEvent, Output pOutput As Ens.Response) As %Status
{
	#Dim eventChange As OEE.Data.EventChange
	#Dim previousChange As OEE.Data.EventChange
	#Dim timeSlice As OEE.Data.OEETimeSlice
	
	Set sc=$$$OK
	
	Try
	{		
		Set dump = ##class(OEE.Data.Dump).%New()
		Set dump.EquipmentId = pInput.EquipmentId
		Set dump.StartTime = pInput.StartTime
		Set dump.EndTime = pInput.EndTime
		Set dump.Tons = pInput.Tons
		
		Set sc = dump.%Save()
		
		// Now we can update the time slice record. We are assuming that a dump is always inside a single shift
		// hence, no fragmentation is necessary
		
		Set timeSlice = ##class(OEE.Data.OEETimeSlice).%New()
		Set timeSlice.Dump = dump
		Set timeSlice.StartTime = dump.StartTime
		Set timeSlice.EndTime = dump.EndTime
		
		Set sc = timeSlice.%Save()
		
	}
	Catch (oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}


Method CompleteEvent(pInput As SampleDispatch.BO.Event.CompleteEvent, Output pOutput As Ens.Response) As %Status
{
	#Dim eventChange As OEE.Data.EventChange
	#Dim previousChange As OEE.Data.EventChange
	#Dim timeSlice As OEE.Data.OEETimeSlice
	
	Set sc=$$$OK
	
	Try
	{		
		Set event = ##class(OEE.Data.EventChange).%New()
		Set event.EquipmentId = pInput.EquipmentId
		Set event.StartTime = pInput.StartTime
		Set event.EndTime = pInput.EndTime
		Set event.NewStatusCode = pInput.ReasonCode
		
		Set sc = event.%Save()
		
		// Now we can update the time slice record. We are assuming that a dump is always inside a single shift
		// hence, no fragmentation is necessary
		
		Set timeSlice = ##class(OEE.Data.OEETimeSlice).%New()
		Set timeSlice.EventChange = event
		Set timeSlice.StartTime = event.StartTime
		Set timeSlice.EndTime = event.EndTime
		
		Set sc = timeSlice.%Save()
		
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
    <MapItem MessageType="SampleDispatch.BO.Event.CompletedDumpEvent">
        <Method>CompletedDumpEvent</Method>
    </MapItem>
    <MapItem MessageType="SampleDispatch.BO.Event.CompleteEvent">
        <Method>CompleteEvent</Method>
    </MapItem>
</MapItems>
}

}