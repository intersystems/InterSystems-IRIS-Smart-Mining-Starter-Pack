Class ASPMining.CanonicalModel.Equipment.EquipmentCategory Extends %Persistent
{
	/// documentation e.g: Truck, Shovel, etc.
	Property Name As %String;

	/// documentation 
	Property Description As %String;

Storage Default
{
<Data name="EquipmentCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Id</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^ASPMiningF845.EquipmentCa2CAAD</DataLocation>
<DefaultData>EquipmentCategoryDefaultData</DefaultData>
<IdLocation>^ASPMiningF845.EquipmentCa2CAAD</IdLocation>
<IndexLocation>^ASPMiningF845.EquipmentCa2CAAI</IndexLocation>
<StreamLocation>^ASPMiningF845.EquipmentCa2CAAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}