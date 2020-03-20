Class ASPMining.CanonicalModel.Personnel.CrewRegistry Extends %Persistent
{
	/// documentation
	Property OperatorList As %Library.ArrayOfObjects;
Storage Default
{
<Data name="CrewRegistryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Id</Value>
</Value>
<Value name="3">
<Value>OperatorList</Value>
</Value>
</Data>
<DataLocation>^ASPMining.Can1320.CrewRegistryD</DataLocation>
<DefaultData>CrewRegistryDefaultData</DefaultData>
<IdLocation>^ASPMining.Can1320.CrewRegistryD</IdLocation>
<IndexLocation>^ASPMining.Can1320.CrewRegistryI</IndexLocation>
<StreamLocation>^ASPMining.Can1320.CrewRegistryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}