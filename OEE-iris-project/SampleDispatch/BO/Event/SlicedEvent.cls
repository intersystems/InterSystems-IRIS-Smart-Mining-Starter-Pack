Class SampleDispatch.BO.Event.SlicedEvent Extends (%Persistent,Ens.Request)
{
	/// Shift where this event happened
	Property ShiftId As %Integer;
	/// Equipment that generated this event
	Property EquipmentId As %String;
	/// Status Reason Link
	Property StatusReasonId As %String;
	/// Status Type Link
	Property StatusTypeId As %String;
	/// Start date of the event
	Property SliceStartDate As %DateTime;
	/// Calculated duration of the event
	Property PartialDuration As %Float;
Storage Default
{
<Data name="SlicedEventDefaultData">
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
<Value>ShiftId</Value>
</Value>
<Value name="9">
<Value>EquipmentId</Value>
</Value>
<Value name="10">
<Value>StatusReasonId</Value>
</Value>
<Value name="11">
<Value>StatusTypeId</Value>
</Value>
</Data>
<DataLocation>^SampleDispatch51FA.SlicedEventD</DataLocation>
<DefaultData>SlicedEventDefaultData</DefaultData>
<IdLocation>^SampleDispatch51FA.SlicedEventD</IdLocation>
<IndexLocation>^SampleDispatch51FA.SlicedEventI</IndexLocation>
<StreamLocation>^SampleDispatch51FA.SlicedEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}