/// This Class unifies the production events and operation events such that each row represents only 1 change in status or production for each equipment.
/// 
/// The duration field of each field is only calculated when a new event is received and then the difference is calculated.
/// 
/// LoadEvents + DumpEvents + StatusEvents
/// 
Class ASPMining.CanonicalModel.Operation.UnifiedEvents Extends %Persistent
{
	/// Related Equipment has to exist
	Property Equipment As ASPMining.CanonicalModel.Equipment.Equipment;
	
	/// Related Shift has to exist
	Property Shift As ASPMining.CanonicalModel.Planning.Shift;
	
	/// Production Event, NEED TO ADD THIS UNIFIED TABLE
	Property ProductionEvent As ASPMining.CanonicalModel.Production.ProductionEvent;
	
	/// Status Event
	Property StatusEvent As ASPMining.CanonicalModel.Operation.StatusEvent;
	
	/// Duration in seconds of this state, is the time between this interval and the next
	Property Duration As %Integer;
	
	
	index EquipmentIndex on Equipment;
	index ShiftIndex on Shift;
	index ProductionEventIndex on ProductionEvent;
	index StatusEventIndex on StatusEvent;
	
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
</Data>
<DataLocation>^ASPMining.CaB953.UnifiedEventsD</DataLocation>
<DefaultData>UnifiedEventsDefaultData</DefaultData>
<IdLocation>^ASPMining.CaB953.UnifiedEventsD</IdLocation>
<IndexLocation>^ASPMining.CaB953.UnifiedEventsI</IndexLocation>
<StreamLocation>^ASPMining.CaB953.UnifiedEventsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}