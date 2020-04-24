Class SampleDispatch.BO.Event.CompleteEvent Extends %Persistent
{	

Property Id As %Integer;

Property ShiftId As %Integer;

Property EquipmentId As %String;

Property StartTime As %TimeStamp;

Property EndTime As %TimeStamp;

Property Duration As %Integer;

Property StatusReasonId As %Integer;

/// documentation
Property StatusReasonDescription As %String;

Property StatusTypeId As %Integer;

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
<Value name="7">
<Value>Duration</Value>
</Value>
<Value name="8">
<Value>Id</Value>
</Value>
<Value name="9">
<Value>ShiftId</Value>
</Value>
<Value name="10">
<Value>StatusReasonId</Value>
</Value>
<Value name="11">
<Value>StatusTypeId</Value>
</Value>
<Value name="12">
<Value>StatusReasonDescription</Value>
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