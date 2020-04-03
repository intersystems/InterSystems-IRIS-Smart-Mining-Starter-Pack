/// History of status changes of equipment or other elements
Class ASPMining.CanonicalModel.Operation.StatusEvent Extends %Persistent
{
/// documentation
Property Equipment As ASPMining.CanonicalModel.Equipment.Equipment;
/// documentation
Property StatusReason As StatusReason;
/// documentation
Property StatusType As StatusType;

Storage Default
{
<Data name="StatusEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Equipment</Value>
</Value>
<Value name="3">
<Value>StatusReason</Value>
</Value>
<Value name="4">
<Value>StatusType</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanoB953.StatusEventD</DataLocation>
<DefaultData>StatusEventDefaultData</DefaultData>
<IdLocation>^ASPMining.CanoB953.StatusEventD</IdLocation>
<IndexLocation>^ASPMining.CanoB953.StatusEventI</IndexLocation>
<StreamLocation>^ASPMining.CanoB953.StatusEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}