Class SampleDispatch.Eqmt Extends %Persistent
{
/// documentation
Property Eqmt As %Integer;
/// documentation
Property Name As %String;

index EqmtIndex on Eqmt [Unique ];

Storage Default
{
<Data name="EqmtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Eqmt</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^SampleDispatch.EqmtD</DataLocation>
<DefaultData>EqmtDefaultData</DefaultData>
<IdLocation>^SampleDispatch.EqmtD</IdLocation>
<IndexLocation>^SampleDispatch.EqmtI</IndexLocation>
<StreamLocation>^SampleDispatch.EqmtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}