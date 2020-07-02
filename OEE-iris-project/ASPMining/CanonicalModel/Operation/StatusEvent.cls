/// History of status changes of equipment or other elements
Class ASPMining.CanonicalModel.Operation.StatusEvent Extends %Persistent
{
/// Unique Id
Property Id As %BigInt;
/// Shift where this event happened
Property Shift As ASPMining.CanonicalModel.Planning.Shift;
/// Equipment that generated this event
Property Equipment As ASPMining.CanonicalModel.Equipment.Equipment;
/// Status Reason Link
Property StatusReason As StatusReason;
/// Status Type Link
Property StatusType As StatusType;
/// Start date of the event
Property StartDate As %DateTime;
/// End date of the event
Property EndDate As %DateTime;
/// Calculated duration of the event
Property Duration As %Integer;

Parameter DSTIME = "AUTO";

index IdIndex on Id[unique];
index StartTimeIndex on StartDate;
index EndTimeIndex on EndDate;
index StatusReasonIndex on StatusReason [type = bitmap];  //Para mejorar performance al agrupar/buscar por reason
index StatusTypeIndex on StatusType [type = bitmap];
index EquipmentIndex on Equipment [type = bitmap];
index DurationIndex on Duration [type = bitslice];


ClassMethod HourToInt(datetime as %DateTime) as %Integer{
	set hour = 0
	try{
		set hour = $ztimeh($piece(datetime," ",2))
	}catch{
		set hour = 0
	}
	Quit hour
}

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
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>EndTime</Value>
</Value>
<Value name="7">
<Value>Duration</Value>
</Value>
<Value name="8">
<Value>Shift</Value>
</Value>
<Value name="9">
<Value>StartDate</Value>
</Value>
<Value name="10">
<Value>EndDate</Value>
</Value>
<Value name="11">
<Value>Id</Value>
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