Class OEE.Data.EventChange Extends %Persistent
{
	/// documentation
	Property EquipmentId As %String [ Required ];
	/// documentation
	Property StartTime As %TimeStamp [ Required];
	Property EndTime As %TimeStamp;
	/// documentation
	Property NewStatusCode As %String [Required]; /// We can map this to ISO Status Codes, but need to enable a lookup table to match custom codes with ISO codes
Storage Default
{
<Data name="EventChangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EquipmentId</Value>
</Value>
<Value name="3">
<Value>EventTime</Value>
</Value>
<Value name="4">
<Value>NewStatusCode</Value>
</Value>
</Data>
<DataLocation>^OEE.Data.EventChangeD</DataLocation>
<DefaultData>EventChangeDefaultData</DefaultData>
<Description>
<![CDATA[We can map this to ISO Status Codes, but need to enable a lookup table to match custom codes with ISO codes]]></Description>
<IdLocation>^OEE.Data.EventChangeD</IdLocation>
<IndexLocation>^OEE.Data.EventChangeI</IndexLocation>
<StreamLocation>^OEE.Data.EventChangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}