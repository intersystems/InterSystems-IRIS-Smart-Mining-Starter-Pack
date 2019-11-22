Class Vehicles.Truck Extends %Persistent
{
Property General As %String;

Storage Default
{
<Data name="TruckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>General</Value>
</Value>
</Data>
<DataLocation>^Vehicles.TruckD</DataLocation>
<DefaultData>TruckDefaultData</DefaultData>
<IdLocation>^Vehicles.TruckD</IdLocation>
<IndexLocation>^Vehicles.TruckI</IndexLocation>
<StreamLocation>^Vehicles.TruckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}