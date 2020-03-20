Class ASPMining.CanonicalModel.Production.ExchangeEvent Extends %Persistent
{	
	/// documentation
	Property Time As %TimeStamp;
	
	/// documentation
	Property EndTime As %TimeStamp;
	
	/// documentation
	Property Equipment As ASPMining.CanonicalModel.Equipment.Equipment;
	
	/// documentation
	Property Tons As %Float;
	
	
Storage Default
{
<Data name="ExchangeEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Time</Value>
</Value>
<Value name="3">
<Value>EndTime</Value>
</Value>
<Value name="4">
<Value>Equipment</Value>
</Value>
<Value name="5">
<Value>Tons</Value>
</Value>
<Value name="6">
<Value>Id</Value>
</Value>
</Data>
<DataLocation>^ASPMining.Ca4037.ExchangeEventD</DataLocation>
<DefaultData>ExchangeEventDefaultData</DefaultData>
<IdLocation>^ASPMining.Ca4037.ExchangeEventD</IdLocation>
<IndexLocation>^ASPMining.Ca4037.ExchangeEventI</IndexLocation>
<StreamLocation>^ASPMining.Ca4037.ExchangeEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}