/// Information about brand and model of equipment
Class ASPMining.CanonicalModel.Equipment.EquipmentModel Extends %Persistent
{

/// Model of the equipment provided by manufacturer
Property Model As %String;

/// Manufacturer's brand name
Property Brand As %String;

/// Model Description
Property Description As %String;

/// Manufacturer's specified Tonnage of equipment (if applies)
Property NominalCapacityTons As %Float;

Index EquipmentModelIndex On Model [ Unique ];

Storage Default
{
<Data name="EquipmentModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Model</Value>
</Value>
<Value name="3">
<Value>Brand</Value>
</Value>
<Value name="4">
<Value>NominalCapacityTons</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CF845.EquipmentModelD</DataLocation>
<DefaultData>EquipmentModelDefaultData</DefaultData>
<IdLocation>^ASPMining.CF845.EquipmentModelD</IdLocation>
<IndexLocation>^ASPMining.CF845.EquipmentModelI</IndexLocation>
<StreamLocation>^ASPMining.CF845.EquipmentModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
