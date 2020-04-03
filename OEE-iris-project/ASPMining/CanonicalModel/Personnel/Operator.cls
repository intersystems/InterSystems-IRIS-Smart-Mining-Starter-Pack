Class ASPMining.CanonicalModel.Personnel.Operator Extends %Persistent
{	
	/// documentation
	Property Crew As Crew;
	
	/// documentation
	Property FirstName As %String;
	/// documentation
	Property LastName As %String;
	
Storage Default
{
<Data name="OperatorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Id</Value>
</Value>
<Value name="3">
<Value>Crew</Value>
</Value>
<Value name="4">
<Value>OperatorName</Value>
</Value>
<Value name="5">
<Value>FirstName</Value>
</Value>
<Value name="6">
<Value>LastName</Value>
</Value>
</Data>
<DataLocation>^ASPMining.Canonic1320.OperatorD</DataLocation>
<DefaultData>OperatorDefaultData</DefaultData>
<IdLocation>^ASPMining.Canonic1320.OperatorD</IdLocation>
<IndexLocation>^ASPMining.Canonic1320.OperatorI</IndexLocation>
<StreamLocation>^ASPMining.Canonic1320.OperatorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}