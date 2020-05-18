Class ASPMining.CanonicalModel.Production.DumpEvent Extends %Persistent
{
/// documentation
Property DumpId As %BigInt;
/// documentation
Property Shift As ASPMining.CanonicalModel.Planning.Shift;
/// documentation
Property TimeArrive As %DateTime;
/// documentation
Property TimeDump As %DateTime;
/// documentation
Property TimeEmpty As %DateTime;
/// documentation
Property TravelTime As %Integer;
/// documentation
Property LoadEvent As LoadEvent;
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

index DumpIndex on DumpId [Unique ];
Storage Default
{
<Data name="DumpEventDefaultData">
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
<Value>LeadEvent</Value>
</Value>
<Value name="12">
<Value>LoadEvent</Value>
</Value>
<Value name="13">
<Value>DumpId</Value>
</Value>
<Value name="14">
<Value>TimeArrive</Value>
</Value>
<Value name="15">
<Value>TimeDump</Value>
</Value>
<Value name="16">
<Value>TimeEmpty</Value>
</Value>
<Value name="17">
<Value>TravelTime</Value>
</Value>
<Value name="18">
<Value>Grade</Value>
</Value>
</Data>
<DataLocation>^ASPMining.Canoni4037.DumpEventD</DataLocation>
<DefaultData>DumpEventDefaultData</DefaultData>
<IdLocation>^ASPMining.Canoni4037.DumpEventD</IdLocation>
<IndexLocation>^ASPMining.Canoni4037.DumpEventI</IndexLocation>
<StreamLocation>^ASPMining.Canoni4037.DumpEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}