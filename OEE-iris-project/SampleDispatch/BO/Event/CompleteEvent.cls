Class SampleDispatch.BO.Event.CompleteEvent Extends %Persistent
{
	/// documentation
	Property EquipmentId As %String [ Required ];
	
	/// documentation
	Property StartTime As %TimeStamp [ Required];

	/// documentation
	Property EndTime As %TimeStamp [ Required];
	
	/// documentation
	Property ReasonCode As %String [Required];
Storage Default
{
<Data name="CompleteEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EquipmentId</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>EndTime</Value>
</Value>
<Value name="5">
<Value>StatusCode</Value>
</Value>
<Value name="6">
<Value>ReasonCode</Value>
</Value>
</Data>
<DataLocation>^SampleDispat51FA.CompleteEventD</DataLocation>
<DefaultData>CompleteEventDefaultData</DefaultData>
<IdLocation>^SampleDispat51FA.CompleteEventD</IdLocation>
<IndexLocation>^SampleDispat51FA.CompleteEventI</IndexLocation>
<StreamLocation>^SampleDispat51FA.CompleteEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}