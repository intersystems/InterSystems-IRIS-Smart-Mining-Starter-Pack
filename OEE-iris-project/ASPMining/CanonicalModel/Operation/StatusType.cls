/// Type of the status: Operative/Standby/Downtime/Delay
Class ASPMining.CanonicalModel.Operation.StatusType Extends %Persistent
{
/// Type of the status, e.g: 1,2,3,4
Property Type As %String;
/// Description of the status, e.g: Operative, Standby, Downtime, Delay. Very important for Operational KPIs
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