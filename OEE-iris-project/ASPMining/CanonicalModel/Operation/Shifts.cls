Class ASPMining.CanonicalModel.Operation.Shifts Extends %Persistent
{
	/// documentation
	Property ShiftId As %Integer;
	
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
	Property Crew As Crews;
	
	index ShiftIdIndex on ShiftId [unique];
}