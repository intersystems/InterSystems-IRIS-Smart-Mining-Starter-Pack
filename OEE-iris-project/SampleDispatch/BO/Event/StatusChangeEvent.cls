Class SampleDispatch.BO.Event.StatusChangeEvent Extends (%Persistent,Ens.Request)
{
	Property EquimentId As %String [ Required ];
	
	Property EventTime As %TimeStamp [ Required ];
	
	Property NewStatusCode As %String [ Required ];
	
Storage Default
{
<Data name="StatusChangeEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EquimentId</Value>
</Value>
<Value name="3">
<Value>EventTime</Value>
</Value>
<Value name="4">
<Value>NewStatusCode</Value>
</Value>
</Data>
<DataLocation>^SampleDisp51FA.StatusChangDFC6D</DataLocation>
<DefaultData>StatusChangeEventDefaultData</DefaultData>
<IdLocation>^SampleDisp51FA.StatusChangDFC6D</IdLocation>
<IndexLocation>^SampleDisp51FA.StatusChangDFC6I</IndexLocation>
<StreamLocation>^SampleDisp51FA.StatusChangDFC6S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}