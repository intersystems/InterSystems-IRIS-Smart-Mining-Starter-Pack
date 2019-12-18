Class OEE.Data.EventChange Extends %Persistent
{

	/// documentation
	Property EquipmentId As %String [ Required ];
	/// documentation
	Property StartTime As %TimeStamp [ Required];
	Property EndTime As %TimeStamp;
	/// documentation
	Property NewStatusCode As %String [Required]; /// We can map this to ISO Status Codes, but need to enable a lookup table to match custom codes with ISO codes
}