Class ASPMining.CanonicalModel.Operation.StatusEventSliced Extends %Persistent
{
	/// Shift where this event happened
	Property Shift As ASPMining.CanonicalModel.Planning.Shift;
	/// Equipment that generated this event
	Property Equipment As ASPMining.CanonicalModel.Equipment.Equipment;
	/// Status Reason Link
	Property StatusReason As StatusReason;
	/// Status Type Link
	Property StatusType As StatusType;
	/// Start date of the event
	Property SliceStartDate As %DateTime;
	/// Calculated duration of the event
	Property PartialDuration As %Float;
	/// For data source validation purposes only
	Property ddbkey As %Integer;
	
	Parameter DSTIME = "AUTO";
	
	index SliceStartTimeIndex on SliceStartDate [type = index];
	index ddbkeyIndex on ddbkey [type = index];
	index PartialDurationIndex on PartialDuration [type = bitslice]; //Mejorar calculos de SUM/AVG, etc.
Storage Default
{
<Data name="StatusEventSlicedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Shift</Value>
</Value>
<Value name="3">
<Value>Equipment</Value>
</Value>
<Value name="4">
<Value>StatusReason</Value>
</Value>
<Value name="5">
<Value>StatusType</Value>
</Value>
<Value name="6">
<Value>SliceStartDate</Value>
</Value>
<Value name="7">
<Value>PartialDuration</Value>
</Value>
<Value name="8">
<Value>ddbkey</Value>
</Value>
</Data>
<DataLocation>^ASPMiningB953.StatusEvent4F11D</DataLocation>
<DefaultData>StatusEventSlicedDefaultData</DefaultData>
<IdLocation>^ASPMiningB953.StatusEvent4F11D</IdLocation>
<IndexLocation>^ASPMiningB953.StatusEvent4F11I</IndexLocation>
<StreamLocation>^ASPMiningB953.StatusEvent4F11S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}