Class OEE.Data.EventChange Extends %Persistent
{
<<<<<<< HEAD
	Property EquimentId As %String [ Required ];
	
	Property StartTime As %TimeStamp [ Required ];
	
	Property EndTime As %TimeStamp;
	
	Property NewStatusCode As %String [ Required ];

=======
	/// documentation
	Property EquipmentId As %String [ Required ];
	/// documentation
	Property StartTime As %TimeStamp [ Required];
	Property EndTime As %TimeStamp;
	/// documentation
	Property NewStatusCode As %String [Required]; /// We can map this to ISO Status Codes, but need to enable a lookup table to match custom codes with ISO codes
>>>>>>> 44a465827ed9aefa00ade632aae4f0ed73e39717
Storage Default
{
<Data name="EventChangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<<<<<<< HEAD
<Value>EquimentId</Value>
=======
<Value>EquipmentId</Value>
>>>>>>> 44a465827ed9aefa00ade632aae4f0ed73e39717
</Value>
<Value name="3">
<Value>EventTime</Value>
</Value>
<Value name="4">
<Value>NewStatusCode</Value>
</Value>
<<<<<<< HEAD
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^OEE.Data.EventChangeD</DataLocation>
<DefaultData>EventChangeDefaultData</DefaultData>
=======
</Data>
<DataLocation>^OEE.Data.EventChangeD</DataLocation>
<DefaultData>EventChangeDefaultData</DefaultData>
<Description>
<![CDATA[We can map this to ISO Status Codes, but need to enable a lookup table to match custom codes with ISO codes]]></Description>
>>>>>>> 44a465827ed9aefa00ade632aae4f0ed73e39717
<IdLocation>^OEE.Data.EventChangeD</IdLocation>
<IndexLocation>^OEE.Data.EventChangeI</IndexLocation>
<StreamLocation>^OEE.Data.EventChangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}