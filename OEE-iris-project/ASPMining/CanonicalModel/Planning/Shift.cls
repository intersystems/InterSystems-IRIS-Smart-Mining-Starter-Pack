Class ASPMining.CanonicalModel.Planning.Shift Extends %Persistent
{	
/// documentation
Property Date As %DateTime;
/// documentation
Property ShiftType As ShiftType;
	/// documentation
	Property StartTime As %TimeStamp;
	
	/// documentation
	Property Year As %Integer;
	
	/// documentation
	Property Month As %Integer;
	
	/// documentation
	Property Day As %Integer;
	
	/// documentation
	Property DayNight As %Integer;
	
	/// documentation
	Property Crew As ASPMining.CanonicalModel.Equipment.Equipment;
	
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
</Data>
<DataLocation>^ASPMining.CanonicalMB953.ShiftD</DataLocation>
<DefaultData>ShiftDefaultData</DefaultData>
<IdLocation>^ASPMining.CanonicalMB953.ShiftD</IdLocation>
<IndexLocation>^ASPMining.CanonicalMB953.ShiftI</IndexLocation>
<StreamLocation>^ASPMining.CanonicalMB953.ShiftS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}