Class SampleDispatch.Shifts Extends %Persistent
{
		/// documentation
		Property ShiftId As %Integer;
		/// documentation
		Property StartTime As %TimeStamp;
		/// documentation
		Property EndTime As %TimeStamp;
		
		index ShiftIdIndex on ShiftId [unique];
}