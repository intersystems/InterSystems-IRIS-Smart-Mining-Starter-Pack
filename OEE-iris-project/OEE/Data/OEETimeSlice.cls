Class OEE.Data.OEETimeSlice Extends %Persistent
{
	Parameter DSTIME = "AUTO";
	
	Property StartTime As %TimeStamp [ Required ];
	
	Property EndTime As %TimeStamp [ Required ];
		
	/// Sparse
	Property Dump As OEE.Data.Dump;
	
	/// Sparse
	Property EventChange As EventChange;
	
	/// Always be here (coming from Dump or EventChange)
	Property Equipment As %Integer [ Calculated, SqlComputeCode = {
	 
	 	Set {Equipment}=##class(OEE.Data.OEETimeSlice).ComputeEquipment({ID})
	 
	 }, SqlComputed ];
	 
	Property DumpTime As %Integer [ Calculated, SqlComputeCode = { 	
		
			Set {*} = $Select({Dump}'="":##class(OEE.Data.OEETimeSlice).ComputeCalendarTime({StartTime}, {EndTime}), 1:0)
		}, SqlComputed ];
		
	Property IdleTime As %Integer [ Calculated, SqlComputeCode = { 	
		Set {*} = ##class(OEE.Data.OEETimeSlice).ConditionalComputeEventChangeTime({ID},200)
		}, SqlComputed ];

	Property DelayTime As %Integer [ Calculated, SqlComputeCode = { 	
		Set {*} = ##class(OEE.Data.OEETimeSlice).ConditionalComputeEventChangeTime({ID},300)
		}, SqlComputed ];
		
	Property DowntimeTime As %Integer [ Calculated, SqlComputeCode = { 	
		Set {*} = ##class(OEE.Data.OEETimeSlice).ConditionalComputeEventChangeTime({ID},400)
		}, SqlComputed ];

	Property TotalTime As %Integer [ Calculated, SqlComputeCode = { 	
		Set {*} = ##class(OEE.Data.OEETimeSlice).ConditionalComputeEventChangeTime({ID},"")
		}, SqlComputed ];

		
	/// Not really necessary for this to work. It is here just so that our xDBC 
	/// dictionary metadata will reflect that Dump is a foreing key
	ForeignKey DumpFK(Dump) References Dump();
	
	/// The same as above.
	ForeignKey EventChangeFK(EventChange) References EventChange();
	
	ClassMethod ComputeEquipment(pID As %String) As %Integer
	{
		Set obj = ..%OpenId(pID)
		
		If obj.Dump'="" Quit obj.Dump.EquipmentId
		If obj.EventChange'="" Quit obj.EventChange.EquipmentId
		
		Quit ""
	}

	ClassMethod ConditionalComputeEventChangeTime(pID As %String, pStatusCode As %String) As %Integer
	{
		Set obj = ..%OpenId(pID)
		Set iDuration=0

		If (obj.EventChange'="") && ((obj.EventChange.NewStatusCode=pStatusCode) || (pStatusCode=""))
		{
			Set iDuration=$System.SQL.DATEDIFF("ss", obj.StartTime, obj.EndTime)
		}
		
		Quit iDuration
	}

ClassMethod ComputeCalendarTime(pStartDate As %TimeStamp, pEndDate As %TimeStamp) As %Integer
{
	Return $System.SQL.DATEDIFF("ss", pStartDate, pEndDate)
}


Storage Default
{
<Data name="OEETimeSliceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StartTime</Value>
</Value>
<Value name="3">
<Value>EndTime</Value>
</Value>
<Value name="4">
<Value>Dump</Value>
</Value>
<Value name="5">
<Value>EventChange</Value>
</Value>
</Data>
<DataLocation>^OEE.Data.OEETimeSliceD</DataLocation>
<DefaultData>OEETimeSliceDefaultData</DefaultData>
<IdLocation>^OEE.Data.OEETimeSliceD</IdLocation>
<IndexLocation>^OEE.Data.OEETimeSliceI</IndexLocation>
<StreamLocation>^OEE.Data.OEETimeSliceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}