/// List of all possible status change code reasons
Class ASPMining.CanonicalModel.Operation.StatusReason Extends %Persistent
{
/// Reason Unique Id = Concat StatusType+Reason
Property Id As %String;
/// Reason code, e.g: "112"
Property Reason As %String;
/// Link to Status Type
Property StatusType As StatusType;
/// Description for the Reason, e.g: "operator went to restroom"
Property Description As %String;

index IdIndex on Id [unique ];
index ReasonIndex on Reason;
index StatusTypeIndex on StatusType [type = bitmap];

Storage Default
{
<Data name="StatusReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Reason</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>StatusType</Value>
</Value>
<Value name="5">
<Value>Id</Value>
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