/// Narrow area inside a Site where events are generated from, e.g: Loading spot inside Site A.
Class ASPMining.CanonicalModel.Mine.Trip Extends %Persistent
{

/// Unique Id of this Trip
Property Id As %String(MAXLEN = 70);

/// Site to which this Location belongs
Property Name As %String(MAXLEN = 70);

/// Site to which this Location belongs
Property OriginLocation As Location;

/// Site to which this Location belongs
Property DestinationLocation As Location;

/// Reference Time Used to Compare data
Property ReferenceTravelTime As %Double;

/// Minimum Registered Time
Property MinTravelTime As %Double;

/// Maximum Registered Time
Property MaxTravelTime As %Double;

/// Sum of all times of this trip, useful for calculations
Property TotalTravelTime As %BigInt;

/// Amounts of Travels Performed
Property TravelCount As %Double;

Index IdIndex On Id [ Unique ];

Index NameIndex On Name;

Index OriginLocationIndex On OriginLocation;

Index DestinationLocationIndex On DestinationLocation;

Storage Default
{
<Data name="TripDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Id</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>OriginLocation</Value>
</Value>
<Value name="5">
<Value>DestinationLocation</Value>
</Value>
<Value name="6">
<Value>ReferenceTravelTime</Value>
</Value>
<Value name="7">
<Value>MinTravelTime</Value>
</Value>
<Value name="8">
<Value>MaxTravelTime</Value>
</Value>
<Value name="9">
<Value>TravelCount</Value>
</Value>
<Value name="10">
<Value>TotalTravelTime</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanonicalMod2AE.TripD</DataLocation>
<DefaultData>TripDefaultData</DefaultData>
<IdLocation>^ASPMining.CanonicalMod2AE.TripD</IdLocation>
<IndexLocation>^ASPMining.CanonicalMod2AE.TripI</IndexLocation>
<StreamLocation>^ASPMining.CanonicalMod2AE.TripS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
