Class SampleDispatch.Operators Extends %Persistent
{

	/// documentation
	Property Shift as Shifts;
	
	/// documentation
	Property OperatorId As %String;
	
	/// documentation
	Property Eqmt As %Integer;
	
	index OperatorIdIndex on OperatorId [unique];
	
Storage Default
{
<Data name="OperatorsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Shift</Value>
</Value>
<Value name="3">
<Value>OperatorId</Value>
</Value>
<Value name="4">
<Value>Eqmt</Value>
</Value>
</Data>
<DataLocation>^SampleDispatch.OperatorsD</DataLocation>
<DefaultData>OperatorsDefaultData</DefaultData>
<IdLocation>^SampleDispatch.OperatorsD</IdLocation>
<IndexLocation>^SampleDispatch.OperatorsI</IndexLocation>
<StreamLocation>^SampleDispatch.OperatorsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}