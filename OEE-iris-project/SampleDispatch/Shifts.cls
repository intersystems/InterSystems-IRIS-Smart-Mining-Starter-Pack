Class SampleDispatch.Shifts Extends %Persistent
{
	/// documentation
	Property ShiftId As %Integer;
	
	/// documentation
	Property StartTime As %TimeStamp;
	
	/// documentation
	Property EndTime As %TimeStamp;
	
	index ShiftIdIndex on ShiftId [unique];
		
Storage Default
{
<Data name="ShiftsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ShiftId</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^SampleDispatch.ShiftsD</DataLocation>
<DefaultData>ShiftsDefaultData</DefaultData>
<IdLocation>^SampleDispatch.ShiftsD</IdLocation>
<IndexLocation>^SampleDispatch.ShiftsI</IndexLocation>
<StreamLocation>^SampleDispatch.ShiftsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}