Class ASPMining.CanonicalModel.HWMonitoring.OEMEventType Extends %Persistent
{
/// Assigned description of the event: e.g: "generated when driver is over accelerating"
Property Description As %String;
/// Other explainatory content: e.g: "for calibration only purposes"
Property Other As %String;
Storage Default
{
<Data name="OEMEventTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Other</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanE4E6.OEMEventTypeD</DataLocation>
<DefaultData>OEMEventTypeDefaultData</DefaultData>
<IdLocation>^ASPMining.CanE4E6.OEMEventTypeD</IdLocation>
<IndexLocation>^ASPMining.CanE4E6.OEMEventTypeI</IndexLocation>
<StreamLocation>^ASPMining.CanE4E6.OEMEventTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}