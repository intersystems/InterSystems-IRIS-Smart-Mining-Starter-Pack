/// Trip times expected between 2 site locations: From and To
Class ASPMining.CanonicalModel.Production.TripTimes Extends %Persistent
{
	/// Concat Form  + To location Ids, used as index.
	Property TripId As %String;
	
	/// Start location of trip
	Property From As ASPMining.CanonicalModel.Mine.Location;
	
	/// Destination location of trip
	Property To As ASPMining.CanonicalModel.Mine.Location;
	
	/// Expected Time for this trip in seconds
	Property ExpectedTime As %Integer;
	
	index TripIdIndex on TripId [unique];
	index FromIndex on From;
	index ToIndex on To;
Storage Default
{
<Data name="TripTimesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>From</Value>
</Value>
<Value name="3">
<Value>To</Value>
</Value>
<Value name="4">
<Value>ExpectedTime</Value>
</Value>
<Value name="5">
<Value>TripId</Value>
</Value>
</Data>
<DataLocation>^ASPMining.Canoni4037.TripTimesD</DataLocation>
<DefaultData>TripTimesDefaultData</DefaultData>
<IdLocation>^ASPMining.Canoni4037.TripTimesD</IdLocation>
<IndexLocation>^ASPMining.Canoni4037.TripTimesI</IndexLocation>
<StreamLocation>^ASPMining.Canoni4037.TripTimesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}