Class OEE.Data.Dump Extends %Persistent
{
	/// documentation
	Property EquipmentId As %String [ Required ];
	
	/// documentation
	Property StartTime As %TimeStamp [ Required];
	
	Property EndTime As %TimeStamp;

	Property Ton As %Float [ Required ];
		
Storage Default
{
<Data name="DumpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EquipmentId</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>EndTime</Value>
</Value>
<Value name="5">
<Value>Ton</Value>
</Value>
<Value name="6">
<Value>StateEvent</Value>
</Value>
</Data>
<DataLocation>^OEE.Data.DumpD</DataLocation>
<DefaultData>DumpDefaultData</DefaultData>
<IdLocation>^OEE.Data.DumpD</IdLocation>
<IndexLocation>^OEE.Data.DumpI</IndexLocation>
<StreamLocation>^OEE.Data.DumpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}