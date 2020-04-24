/// Type of the status: Operative/Standby/Downtime/Delay
Class ASPMining.CanonicalModel.Operation.StatusType Extends %Persistent
{
/// documentation
Property Type As %String;
Property Description As %String;


index TypeIndex on Type [unique ];
Storage Default
{
<Data name="StatusTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanonB953.StatusTypeD</DataLocation>
<DefaultData>StatusTypeDefaultData</DefaultData>
<IdLocation>^ASPMining.CanonB953.StatusTypeD</IdLocation>
<IndexLocation>^ASPMining.CanonB953.StatusTypeI</IndexLocation>
<StreamLocation>^ASPMining.CanonB953.StatusTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}