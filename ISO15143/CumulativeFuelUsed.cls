/// 11.4 Cumulative Fuel Used (Preferred)
Class ISO15143.CumulativeFuelUsed Extends %Persistent
{

/// 11.5.1 General 
Property General As %String;

/// 11.5.3 Unit of measure of Fuel
Property UnitOfMeasure As %String;

/// 11.5.4 Amount of Fuel used to date 
Property FuelUsedToDate As %Double;

Storage Default
{
<Data name="CumulativeFuelUsedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>general</Value>
</Value>
<Value name="3">
<Value>General</Value>
</Value>
<Value name="4">
<Value>UnitOfMeasure</Value>
</Value>
<Value name="5">
<Value>FuelUsedToDate</Value>
</Value>
</Data>
<DataLocation>^ISO15143.CumulativeFuelUsedD</DataLocation>
<DefaultData>CumulativeFuelUsedDefaultData</DefaultData>
<IdLocation>^ISO15143.CumulativeFuelUsedD</IdLocation>
<IndexLocation>^ISO15143.CumulativeFuelUsedI</IndexLocation>
<StreamLocation>^ISO15143.CumulativeFuelUsedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
