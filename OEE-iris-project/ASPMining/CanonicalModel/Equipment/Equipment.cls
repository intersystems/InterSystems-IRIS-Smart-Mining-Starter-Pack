Class ASPMining.CanonicalModel.Equipment.Equipment Extends %Persistent
{
	/// documentation
	Property Id As %String;
	
	/// documentation
	Property EquipmentCategory As EquipmentCategory;
	/// documentation
	Property EquipmentModel As EquipmentModel;
	
	/// documentation
	Property Name As %String;
	
	Property Capacity As %Float;
	
	index EquipmentIndex on Id [Unique ];

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
<Value name="7">
<Value>EquipmentModel</Value>
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