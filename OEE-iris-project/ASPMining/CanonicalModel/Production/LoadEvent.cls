Class ASPMining.CanonicalModel.Production.LoadEvent Extends %Persistent
{
/// Unique LoadId
Property LoadId As %BigInt;
/// Shift when this Load Happened
Property Shift As ASPMining.CanonicalModel.Planning.Shift;
/// Time when the Truck Arrived
Property TimeArrive As %DateTime;
/// Time when the Load Started
Property TimeLoad As %DateTime;
/// Time when the Load Completed
Property TimeFull As %DateTime;
/// Calculated Travel Time of the vehicle to arrive at the load point
Property TravelTime As %Integer;
/// Next DumpEvent assigned to this Truck
Property DumpEvent As DumpEvent;
/// Location where the Dump happened
Property Location As ASPMining.CanonicalModel.Mine.Location;
/// Truck Link
Property EquipmentTruck As ASPMining.CanonicalModel.Equipment.Equipment;
/// Excavator Link
Property EquipmentExcav As ASPMining.CanonicalModel.Equipment.Equipment;
/// Truck's Operator Link
Property OperatorTruck As ASPMining.CanonicalModel.Personnel.Operator;
/// Excavator's Operator Link
Property OperatorExcav As ASPMining.CanonicalModel.Personnel.Operator;
/// GPS of event (if available)
Property Latitude As %Float;
/// GPS of event (if available)
Property Longitude As %Float;
/// Measured tons of the Dump (if available)
Property MeasuredTons As %Float;
index LoadIndex on LoadId [Unique ];
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
<Value name="12">
<Value>LoadId</Value>
</Value>
<Value name="13">
<Value>TimeArrive</Value>
</Value>
<Value name="14">
<Value>TimeLoad</Value>
</Value>
<Value name="15">
<Value>TimeFull</Value>
</Value>
<Value name="16">
<Value>TravelTime</Value>
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