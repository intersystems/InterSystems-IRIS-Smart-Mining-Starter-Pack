/// History of all OEM Events
Class ASPMining.CanonicalModel.HWMonitoring.OEMEvent Extends %Persistent
{
	/// documentation
	Property OEMEventType As OEMEventType;
	/// documentation
	Property OEMInterface As OEMInterface;
	/// documentation
	Property Shift As ASPMining.CanonicalModel.Planning.Shift;
	/// documentation
	Property Location As ASPMining.CanonicalModel.Mine.Location;
	/// documentation
	Property ReadTime As %DateTime;
	/// documentation
	Property Value As %Float;
	/// documentation
	Property Latitude As %Float;
	/// documentation
	Property Longitude As %Float;
	/// Local value of EquipmentId, not reference to an EquipmentId, in case it changes to a different equipment
	Property EquipmentId As %Integer;
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
</Data>
<DataLocation>^ASPMining.CanonicE4E6.OEMEventD</DataLocation>
<DefaultData>OEMEventDefaultData</DefaultData>
<IdLocation>^ASPMining.CanonicE4E6.OEMEventD</IdLocation>
<IndexLocation>^ASPMining.CanonicE4E6.OEMEventI</IndexLocation>
<StreamLocation>^ASPMining.CanonicE4E6.OEMEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}