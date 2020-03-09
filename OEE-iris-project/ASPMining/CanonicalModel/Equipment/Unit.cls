Class ASPMining.CanonicalModel.Equipment.Unit Extends %Persistent
{
	/// documentation
	Property EqmtCode As %Integer;
	
	/// documentation
	Property Category As EquipmentCategory;
	
	/// documentation
	Property Name As %String;
	
	Property Capacity As %Float;
	
	index EqmtIndex on EqmtCode [Unique ];
Storage Default
{
<Data name="UnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EqmtCode</Value>
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
</Data>
<DataLocation>^ASPMining.CanonicalMoF845.UnitD</DataLocation>
<DefaultData>UnitDefaultData</DefaultData>
<IdLocation>^ASPMining.CanonicalMoF845.UnitD</IdLocation>
<IndexLocation>^ASPMining.CanonicalMoF845.UnitI</IndexLocation>
<StreamLocation>^ASPMining.CanonicalMoF845.UnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}