Class SampleDispatch.Events Extends %Persistent
{
		/// documentation
		Property Time As %TimeStamp;
		
		/// documentation
		Property Code As EventCodes [ Required ];
		
		/// documentation
		Property Eqmt As %Integer;
		
		
Storage Default
{
<Data name="EventsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Time</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Eqmt</Value>
</Value>
</Data>
<DataLocation>^SampleDispatch.EventsD</DataLocation>
<DefaultData>EventsDefaultData</DefaultData>
<IdLocation>^SampleDispatch.EventsD</IdLocation>
<IndexLocation>^SampleDispatch.EventsI</IndexLocation>
<StreamLocation>^SampleDispatch.EventsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}