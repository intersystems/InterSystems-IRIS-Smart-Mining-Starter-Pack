Class SampleDispatch.Dumps Extends %Persistent
{

/// documentation
Property Time As %TimeStamp;

/// documentation
Property EndTime As %TimeStamp;

/// documentation
Property Eqmt As Eqmt;

/// documentation
Property Tons As %Float;

Storage Default
{
<Data name="DumpsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Time</Value>
</Value>
<Value name="3">
<Value>EndTime</Value>
</Value>
<Value name="4">
<Value>Eqmt</Value>
</Value>
<Value name="5">
<Value>Tons</Value>
</Value>
</Data>
<DataLocation>^SampleDispatch.DumpsD</DataLocation>
<DefaultData>DumpsDefaultData</DefaultData>
<IdLocation>^SampleDispatch.DumpsD</IdLocation>
<IndexLocation>^SampleDispatch.DumpsI</IndexLocation>
<StreamLocation>^SampleDispatch.DumpsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}