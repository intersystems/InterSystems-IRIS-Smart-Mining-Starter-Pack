Class ASPMining.CanonicalModel.Planning.Shift Extends %Persistent
{	
/// Uniquie Shift Id
Property Id As %Integer;
/// Start time of the Shift
Property DateTime As %DateTime;
/// Auxiliar variable, offset in seconds from start of the day
Property StartSeconds As %Integer;
/// Auxiliar variable, offset in days from start of IRIS internal time
Property StartDay As %Integer;
/// Shift's Shift Type
Property ShiftType As ShiftType;
/// Crew Assigned to this shift
Property Crew As ASPMining.CanonicalModel.Personnel.Crew;
	
index ShiftIndex on Id [unique ];
index CrewIndex on Crew [type = bitmap];
	
Storage Default
{
<Data name="ShiftDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ShiftId</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>Year</Value>
</Value>
<Value name="5">
<Value>Month</Value>
</Value>
<Value name="6">
<Value>Day</Value>
</Value>
<Value name="7">
<Value>DayNight</Value>
</Value>
<Value name="8">
<Value>Crew</Value>
</Value>
<Value name="9">
<Value>Id</Value>
</Value>
<Value name="10">
<Value>Date</Value>
</Value>
<Value name="11">
<Value>ShiftType</Value>
</Value>
<Value name="12">
<Value>DateTime</Value>
</Value>
<Value name="13">
<Value>StartSeconds</Value>
</Value>
<Value name="14">
<Value>StartDay</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanonicalMB953.ShiftD</DataLocation>
<DefaultData>ShiftDefaultData</DefaultData>
<IdLocation>^ASPMining.CanonicalMB953.ShiftD</IdLocation>
<IndexLocation>^ASPMining.CanonicalMB953.ShiftI</IndexLocation>
<StreamLocation>^ASPMining.CanonicalMB953.ShiftS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}