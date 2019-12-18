Class OEE.Data.EventChange Extends %Persistent
{
	Property EquimentId As %String [ Required ];
	
	Property StartTime As %TimeStamp [ Required ];
	
	Property EndTime As %TimeStamp;
	
	Property NewStatusCode As %String [ Required ];

Storage Default
{
<Data name="EventChangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EquimentId</Value>
</Value>
<Value name="3">
<Value>EventTime</Value>
</Value>
<Value name="4">
<Value>NewStatusCode</Value>
</Value>
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^OEE.Data.EventChangeD</DataLocation>
<DefaultData>EventChangeDefaultData</DefaultData>
<IdLocation>^OEE.Data.EventChangeD</IdLocation>
<IndexLocation>^OEE.Data.EventChangeI</IndexLocation>
<StreamLocation>^OEE.Data.EventChangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}