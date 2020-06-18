/// This table holds all the ProductionEvents of the production cycle in one table:
/// 
/// Transit to Load, Waiting to Load, Loading, Transit to Dump, Waiting for Dump and Dumping
Class ASPMining.CanonicalModel.Production.ProductionEvent Extends %Persistent
{
	/// Equipment asociated, must exist
	Property Equipment As ASPMining.CanonicalModel.Equipment.Equipment;
	
	/// Production Status Type: loading, dump, waiting, etc.
	Property ProductionStatusType As ProductionStatusType;
	
	/// Location where event happens, should exist
	Property Location As ASPMining.CanonicalModel.Mine.Location;
	
	/// Target Location where the equipment is going, only when this event is a moving event
	Property TargetLocation As ASPMining.CanonicalModel.Mine.Location;
	
	/// Measured Tons related to this event
	Property MeasuredTons As %Double;
	
	/// Registration Time of the Event, is the only time that matters
	Property StartTime As %DateTime;	
	
	index StartTimeIndex on StartTime;
	index EquipmentIndex on Equipment;
	index LocationIndex on Location;
	index TargetLocationIndex on TargetLocation;
	
Storage Default
{
<Data name="ProductionEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Equipment</Value>
</Value>
<Value name="3">
<Value>ProductionStatusType</Value>
</Value>
<Value name="4">
<Value>Location</Value>
</Value>
<Value name="5">
<Value>TargetLocation</Value>
</Value>
<Value name="6">
<Value>StartTime</Value>
</Value>
<Value name="7">
<Value>MeasuredTons</Value>
</Value>
</Data>
<DataLocation>^ASPMining4037.ProductionEv563D</DataLocation>
<DefaultData>ProductionEventDefaultData</DefaultData>
<IdLocation>^ASPMining4037.ProductionEv563D</IdLocation>
<IndexLocation>^ASPMining4037.ProductionEv563I</IndexLocation>
<StreamLocation>^ASPMining4037.ProductionEv563S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}