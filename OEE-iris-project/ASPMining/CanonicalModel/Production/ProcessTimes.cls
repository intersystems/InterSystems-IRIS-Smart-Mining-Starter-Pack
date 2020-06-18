/// Times expecteds for Loads and Dumps for each Site
Class ASPMining.CanonicalModel.Production.ProcessTimes Extends %Persistent
{
	/// Production Type of the process, this table should not have "traveling" types
	Property ProductionStatusType As ProductionStatusType;
	
	/// Location for this site
	Property Location As ASPMining.CanonicalModel.Mine.Location;
	
	/// ExpectedTime for this process at this site in seconds
	Property ExpectedTime As %Integer;
	
	
	index LocationIndex on Location;
	index ProductionStatusTypeIndex on ProductionStatusType [type = bitmap];
Storage Default
{
<Data name="ProcessTimesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductionStatusType</Value>
</Value>
<Value name="3">
<Value>Location</Value>
</Value>
<Value name="4">
<Value>ExpectedTime</Value>
</Value>
</Data>
<DataLocation>^ASPMining.Can4037.ProcessTimesD</DataLocation>
<DefaultData>ProcessTimesDefaultData</DefaultData>
<IdLocation>^ASPMining.Can4037.ProcessTimesD</IdLocation>
<IndexLocation>^ASPMining.Can4037.ProcessTimesI</IndexLocation>
<StreamLocation>^ASPMining.Can4037.ProcessTimesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}