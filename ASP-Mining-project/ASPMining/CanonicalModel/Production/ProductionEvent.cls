/// This table holds all the ProductionEvents of the production cycle in one table:
/// 
/// Transit to Load, Waiting to Load, Loading, Transit to Dump, Waiting for Dump and Dumping
Class ASPMining.CanonicalModel.Production.ProductionEvent Extends %Persistent
{
	/// Unique Id
	Property Id As %BigInt;
	
	/// Equipment asociated, must exist
	Property Equipment As ASPMining.CanonicalModel.Equipment.Equipment;
	
	/// Production Status Type: loading, dump, waiting, etc.
	Property ProductionStatusType As ProductionStatusType;
	
	/// Location where event happens, should exist
	Property Location As ASPMining.CanonicalModel.Mine.Location;
	
	/// Target Location where the equipment came from, only exists when this event is a moving ProductionEventType e.g: transitToDump, transitToLoad
	Property PreviousLocation As ASPMining.CanonicalModel.Mine.Location;
	
	/// Measured Tons related to this event
	Property MeasuredTons As %Double;
	
	/// Duration of the Event in Seconds
	Property Duration As %Double;
	
	/// Registration Time of the Event, is the only time that matters
	Property Shift As ASPMining.CanonicalModel.Planning.Shift;	
	
	/// Registration Time of the Event, is the only time that matters
	Property StartTime As %DateTime;	
	
	index IdIndex on Id [unique];
	index StartTimeIndex on StartTime;
	index EquipmentIndex on Equipment [type = bitmap];
	index LocationIndex on Location [type = bitmap];
	index PreviousLocationIndex on PreviousLocation [type = bitmap];
	index ShiftIndex on Shift [type = bitmap];
	
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
<Value>PreviousLocation</Value>
</Value>
<Value name="6">
<Value>MeasuredTons</Value>
</Value>
<Value name="7">
<Value>Shift</Value>
</Value>
<Value name="8">
<Value>StartTime</Value>
</Value>
<Value name="9">
<Value>Duration</Value>
</Value>
<Value name="10">
<Value>Id</Value>
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