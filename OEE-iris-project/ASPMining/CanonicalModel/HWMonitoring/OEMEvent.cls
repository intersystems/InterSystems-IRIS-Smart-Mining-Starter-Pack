/// History of all OEM Events
Class ASPMining.CanonicalModel.HWMonitoring.OEMEvent Extends %Persistent
{
	/// Unique Id of event provided by Mining software
	Property Id As %Integer;
	/// Type of the event, e.g: Overspeed event.
	Property OEMEventType As OEMEventType;
	/// HW Interface that generator this event
	Property OEMInterface As OEMInterface;
	/// Shift when this event happened
	Property Shift As ASPMining.CanonicalModel.Planning.Shift;
	/// Mine Site location where the event happened
	Property Location As ASPMining.CanonicalModel.Mine.Location;
	/// Reading time of the event
	Property ReadTime As %DateTime;
	/// Value of the event (if it has one)
	Property Value As %Float;
	/// GPS Latitude if available
	Property Latitude As %Float;
	/// GPS Longitude if available
	Property Longitude As %Float;
	/// Local copy of EquipmentId for this event, not reference to an Equipment Object, in case it changes to a different equipment
	Property EquipmentId As %Integer;
	
	index OEMEventIndex on Id [unique];
Storage Default
{
<Data name="OEMEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OEMEventType</Value>
</Value>
<Value name="3">
<Value>OEMInterface</Value>
</Value>
<Value name="4">
<Value>Shift</Value>
</Value>
<Value name="5">
<Value>Location</Value>
</Value>
<Value name="6">
<Value>ReadTime</Value>
</Value>
<Value name="7">
<Value>Value</Value>
</Value>
<Value name="8">
<Value>Latitude</Value>
</Value>
<Value name="9">
<Value>Longitude</Value>
</Value>
<Value name="10">
<Value>EquipmentId</Value>
</Value>
<Value name="11">
<Value>Id</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanonicE4E6.OEMEventD</DataLocation>
<DefaultData>OEMEventDefaultData</DefaultData>
<IdLocation>^ASPMining.CanonicE4E6.OEMEventD</IdLocation>
<IndexLocation>^ASPMining.CanonicE4E6.OEMEventI</IndexLocation>
<StreamLocation>^ASPMining.CanonicE4E6.OEMEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}