/// A completed dump has an EndTime and all the information about that dump
Class SampleDispatch.BO.Event.CompletedDumpEvent Extends (%Persistent,Ens.Request)
{
	/// documentation
	Property EquipmentId As %String [ Required ];
	
	/// documentation
	Property StartTime As %TimeStamp [ Required];

	/// documentation
	Property EndTime As %TimeStamp [ Required];
	
	/// documentation
	Property Tons As %Float [Required];
Storage Default
{
<Data name="CompletedDumpEventDefaultData">
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
<Value>Tons</Value>
</Value>
</Data>
<DataLocation>^SampleDisp51FA.CompletedDumA00D</DataLocation>
<DefaultData>CompletedDumpEventDefaultData</DefaultData>
<IdLocation>^SampleDisp51FA.CompletedDumA00D</IdLocation>
<IndexLocation>^SampleDisp51FA.CompletedDumA00I</IndexLocation>
<StreamLocation>^SampleDisp51FA.CompletedDumA00S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}