Class ASPMining.CanonicalModel.Equipment.EquipmentCategory Extends %Persistent
{
	/// documentation
	Property CategoryId As %Integer;
	
	/// documentation e.g: Truck, Shovel, etc.
	Property Name As %Integer;

	index CategoryIdIndex on CategoryId [Unique ];
Storage Default
{
<Data name="EquipmentCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryId</Value>
</Value>
<Value name="3">
<Value>Name</Value>
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