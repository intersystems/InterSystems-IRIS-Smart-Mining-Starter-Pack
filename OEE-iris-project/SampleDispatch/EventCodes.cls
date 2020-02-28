Class SampleDispatch.EventCodes Extends %Persistent
{

	/// documentation
	Property Code As %Integer;
	/// documentation
	Property Description As %String;
	/// documentation
	/// Property CodeType As type;
	
	Index CodeIndex On Code [ Unique ];
	
	
Storage Default
{
<Data name="EventCodesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^SampleDispatch.EventCodesD</DataLocation>
<DefaultData>EventCodesDefaultData</DefaultData>
<IdLocation>^SampleDispatch.EventCodesD</IdLocation>
<IndexLocation>^SampleDispatch.EventCodesI</IndexLocation>
<StreamLocation>^SampleDispatch.EventCodesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}