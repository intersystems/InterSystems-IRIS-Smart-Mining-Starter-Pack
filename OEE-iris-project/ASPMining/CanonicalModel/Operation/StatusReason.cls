/// List of all possible status change code reasons
Class ASPMining.CanonicalModel.Operation.StatusReason Extends %Persistent
{
/// documentation
Property Reason As %String;
Storage Default
{
<Data name="StatusReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Reason</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanB953.StatusReasonD</DataLocation>
<DefaultData>StatusReasonDefaultData</DefaultData>
<IdLocation>^ASPMining.CanB953.StatusReasonD</IdLocation>
<IndexLocation>^ASPMining.CanB953.StatusReasonI</IndexLocation>
<StreamLocation>^ASPMining.CanB953.StatusReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}