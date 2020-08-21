/// History of all OEM Events
Class ASPMining.CanonicalModel.HWMonitoring.OEMEvent Extends %Persistent
{

Parameter DSTIME = "AUTO";

/// Unique Id of event provided by Mining software
Property Id As %Integer;

/// Type of the event, e.g: Overspeed event.
Property OEMEventType As OEMEventType;

// Property OEMInterface As OEMInterface;

// Property Shift As ASPMining.CanonicalModel.Planning.Shift;

// Property Location As ASPMining.CanonicalModel.Mine.Location;

/// HW Interface that generator this event
/// Shift when this event happened
/// Mine Site location where the event happened
/// Reading time of the event
Property ReadTime As %DateTime;

/// Value of the event (if it has one)
Property Value As %Float;

// Property Latitude As %Float;

// Property Longitude As %Float;

/// GPS Latitude if available
/// GPS Longitude if available
/// Local copy of EquipmentId for this event, not reference to an Equipment Object, in case it changes to a different equipment
Property Equipment As ASPMining.CanonicalModel.Equipment.Equipment;

Index OEMEventIndex On Id [ Unique ];

Index ReadTimeIndex On ReadTime;

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
<Value name="12">
<Value>Equipment</Value>
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
