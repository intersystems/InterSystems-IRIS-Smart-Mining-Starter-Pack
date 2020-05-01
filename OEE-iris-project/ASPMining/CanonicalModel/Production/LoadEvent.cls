Class ASPMining.CanonicalModel.Production.LoadEvent Extends %Persistent
{
/// documentation
Property Shift As ASPMining.CanonicalModel.Planning.Shift;
/// documentation
Property DumpEvent As DumpEvent;
/// documentation
Property Location As ASPMining.CanonicalModel.Mine.Location;
/// documentation
Property EquipmentTruck As ASPMining.CanonicalModel.Equipment.Equipment;
/// documentation
Property EquipmentExcav As ASPMining.CanonicalModel.Equipment.Equipment;
/// documentation
Property OperatorTruck As ASPMining.CanonicalModel.Personnel.Operator;
/// documentation
Property OperatorExcav As ASPMining.CanonicalModel.Personnel.Operator;
/// documentation
Property Latitude As %Float;
/// documentation
Property Longitude As %Float;
/// documentation
Property MeasuredTons As %Float;
Storage Default
{
<Data name="LoadEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Shift</Value>
</Value>
<Value name="3">
<Value>Location</Value>
</Value>
<Value name="4">
<Value>EquipmentTruck</Value>
</Value>
<Value name="5">
<Value>EquipmentExcav</Value>
</Value>
<Value name="6">
<Value>OperatorTruck</Value>
</Value>
<Value name="7">
<Value>OperatorExcav</Value>
</Value>
<Value name="8">
<Value>Latitude</Value>
</Value>
<Value name="9">
<Value>Longitude</Value>
</Value>
<Value name="10">
<Value>MeasuredTons</Value>
</Value>
<Value name="11">
<Value>DumpEvent</Value>
</Value>
</Data>
<DataLocation>^ASPMining.Canoni4037.LoadEventD</DataLocation>
<DefaultData>LoadEventDefaultData</DefaultData>
<IdLocation>^ASPMining.Canoni4037.LoadEventD</IdLocation>
<IndexLocation>^ASPMining.Canoni4037.LoadEventI</IndexLocation>
<StreamLocation>^ASPMining.Canoni4037.LoadEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}