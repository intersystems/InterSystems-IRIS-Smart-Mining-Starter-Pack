Class ASPMining.CanonicalModel.Equipment.Equipment Extends %Persistent
{
	/// documentation
	Property EquipmentCategory As EquipmentCategory;
	
	/// documentation
	Property Name As %String;
	
	Property Capacity As %Float;


Storage Default
{
<Data name="EquipmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Id</Value>
</Value>
<Value name="3">
<Value>Category</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Capacity</Value>
</Value>
<Value name="6">
<Value>EquipmentCategory</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanoniF845.EquipmentD</DataLocation>
<DefaultData>EquipmentDefaultData</DefaultData>
<IdLocation>^ASPMining.CanoniF845.EquipmentD</IdLocation>
<IndexLocation>^ASPMining.CanoniF845.EquipmentI</IndexLocation>
<StreamLocation>^ASPMining.CanoniF845.EquipmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}