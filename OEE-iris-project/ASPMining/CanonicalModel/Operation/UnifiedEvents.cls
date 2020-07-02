/// This Class unifies the production events and operation events such that each row represents only 1 change in status or production for each equipment.
/// 
/// The duration field of each field is only calculated when a new event is received and then the difference is calculated.
/// 
/// LoadEvents + DumpEvents + StatusEvents
/// 
Class ASPMining.CanonicalModel.Operation.UnifiedEvents Extends %Persistent
{	
	/// Unique Id
	Property Id As %BigInt;
	/// Related Equipment has to exist
	Property Equipment As ASPMining.CanonicalModel.Equipment.Equipment;
	
	/// Related Shift has to exist
	Property Shift As ASPMining.CanonicalModel.Planning.Shift;
	
	/// Production Event, NEED TO ADD THIS UNIFIED TABLE
	Property ProductionEvent As ASPMining.CanonicalModel.Production.ProductionEvent;
	
	/// Status Event
	Property StatusEvent As ASPMining.CanonicalModel.Operation.StatusEvent;
	
	/// Saves the datetime of the received event to simplify the Duration calculation of next event
	Property EventDateTime As %DateTime;
	
	/// Duration in seconds of this state, is the time between this interval and the next
	Property Duration As %Integer;
	
	
	index IdIndex on Id [unique];
	index EquipmentIndex on Equipment;
	index ShiftIndex on Shift;
	index ProductionEventIndex on ProductionEvent;
	index StatusEventIndex on StatusEvent;
	index EventDateTimeIndex on EventDateTime;
	
Storage Default
{
<Data name="UnifiedEventsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Equipment</Value>
</Value>
<Value name="3">
<Value>Shift</Value>
</Value>
<Value name="4">
<Value>StatusEvent</Value>
</Value>
<Value name="5">
<Value>Duration</Value>
</Value>
<Value name="6">
<Value>ProductionEvent</Value>
</Value>
<Value name="7">
<Value>EventDateTime</Value>
</Value>
<Value name="8">
<Value>Id</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CaB953.UnifiedEventsD</DataLocation>
<DefaultData>UnifiedEventsDefaultData</DefaultData>
<IdLocation>^ASPMining.CaB953.UnifiedEventsD</IdLocation>
<IndexLocation>^ASPMining.CaB953.UnifiedEventsI</IndexLocation>
<StreamLocation>^ASPMining.CaB953.UnifiedEventsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}