/// Get Sliced time windows of production states.
Class ASPMining.CanonicalModel.Production.ProductionEventSliced Extends %Persistent
{
	/// Shift where this event happened
	Property Shift As ASPMining.CanonicalModel.Planning.Shift;
	/// Status Type Link
	Property ProductionStatusType As ProductionStatusType;
	/// Start date of the event
	Property SliceStartDate As %DateTime;
	/// Calculated duration of the event
	Property PartialDuration As %Float;
	/// Event Start Date INSIDE this time slot
	Property EventStartDate As %DateTime;
	/// Real End date of the event
	Property EventEndDate As %DateTime;
	
	/// For data source validation purposes only
	Property ddbkey As %String;
	
	/// Measured tons of the Dump (if available)
	Property MeasuredTons As %Float;
	/// Truck Link
	Property EquipmentTruck As ASPMining.CanonicalModel.Equipment.Equipment;
	/// Excavator Link
	Property EquipmentExcav As ASPMining.CanonicalModel.Equipment.Equipment;
	/// Location of origin of the cycle
	Property LoadLocation As ASPMining.CanonicalModel.Mine.Location;
	/// Location of origin of the cycle
	Property DumpLocation As ASPMining.CanonicalModel.Mine.Location;
	
	Parameter DSTIME = "AUTO";
	
	index SliceStartTimeIndex on SliceStartDate [type = index];
	index ddbkeyIndex on ddbkey [type = index];
	index PartialDurationIndex on PartialDuration [type = bitslice]; //Mejorar calculos de SUM/AVG, etc.
	
Storage Default
{
<Data name="ProductionEventSlicedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Shift</Value>
</Value>
<Value name="3">
<Value>Equipment</Value>
</Value>
<Value name="4">
<Value>ProductionStatusType</Value>
</Value>
<Value name="5">
<Value>SliceStartDate</Value>
</Value>
<Value name="6">
<Value>PartialDuration</Value>
</Value>
<Value name="7">
<Value>EventStartDate</Value>
</Value>
<Value name="8">
<Value>EventEndDate</Value>
</Value>
<Value name="9">
<Value>ddbkey</Value>
</Value>
<Value name="10">
<Value>MeasuredTons</Value>
</Value>
<Value name="11">
<Value>EquipmentTruck</Value>
</Value>
<Value name="12">
<Value>EquipmentExcav</Value>
</Value>
<Value name="13">
<Value>EventLocation</Value>
</Value>
<Value name="14">
<Value>LoadLocation</Value>
</Value>
<Value name="15">
<Value>DumpLocation</Value>
</Value>
</Data>
<DataLocation>^ASPMining4037.ProductionEC09ED</DataLocation>
<DefaultData>ProductionEventSlicedDefaultData</DefaultData>
<IdLocation>^ASPMining4037.ProductionEC09ED</IdLocation>
<IndexLocation>^ASPMining4037.ProductionEC09EI</IndexLocation>
<StreamLocation>^ASPMining4037.ProductionEC09ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}