Class SampleDispatch.Loads Extends %Persistent
{
/// documentation
Property Time As %TimeStamp;
/// documentation
Property Eqmt As Eqmt;
/// documentation
Property Tons As %Float;


Storage Default
{
<Data name="LoadsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Time</Value>
</Value>
<Value name="3">
<Value>Eqmt</Value>
</Value>
<Value name="4">
<Value>Tons</Value>
</Value>
</Data>
<DataLocation>^SampleDispatch.LoadsD</DataLocation>
<DefaultData>LoadsDefaultData</DefaultData>
<IdLocation>^SampleDispatch.LoadsD</IdLocation>
<IndexLocation>^SampleDispatch.LoadsI</IndexLocation>
<StreamLocation>^SampleDispatch.LoadsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}