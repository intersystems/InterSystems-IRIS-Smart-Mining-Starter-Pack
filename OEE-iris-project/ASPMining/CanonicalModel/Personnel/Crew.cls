/// A crew is a label used for referencing Operator groups
Class ASPMining.CanonicalModel.Personnel.Crew Extends %Persistent
{
	/// documentation
	
	Property Name As %String;
	
	/// documentation
	Index CrewIndex On Name [unique];
	
Storage Default
{
<Data name="CrewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Id</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanonicalMo1320.CrewD</DataLocation>
<DefaultData>CrewDefaultData</DefaultData>
<IdLocation>^ASPMining.CanonicalMo1320.CrewD</IdLocation>
<IndexLocation>^ASPMining.CanonicalMo1320.CrewI</IndexLocation>
<StreamLocation>^ASPMining.CanonicalMo1320.CrewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}