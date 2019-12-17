Class IRISDemo.Data.DowntimeEvents Extends %Persistent
{

Property ProductionOrder As ProductionOrderChange [ Required ];

ForeignKey ProductionOrderFK(ProductionOrder) References ProductionOrderChange();

Property StartTime As %TimeStamp [ Required ];

Property ReasonCode As %String [ Required ];

Property ReasonCategory As %String [ Calculated, SqlComputeCode = { Set {*}=##class(IRISDemo.Data.DowntimeEvents).ComputeCategory({ReasonCode})}, SqlComputed ];

Property EndTime As %TimeStamp [ Required ];

Index StartTimeIDX On StartTime;

Index EndTimeIDX On EndTime;

Trigger UpdateCube [ Event = UPDATE, Foreach = row/object, Time = AFTER ]
{
	set downtimeID={ID}
	set sql="SELECT ID FROM TimeSlice where DowntimeEvent=?"
	set rs=##class(%SQL.Statement).%ExecDirect(,sql,downtimeID)
	while rs.%Next()
	{
		do ##class(%DeepSee.Utils).%ProcessFact("TimeSlice",rs.%Get("ID"))
		
		/*
	
		Alternatively add the IDs to the list of things to be done
		which will be picked up on the next Cube synchronization (configurable)
	
		do ##class(%DeepSee.Utils).%SetDSTime("IRISDemo.Data.TimeSlice",rs.%Get("ID"),0)
	
		*/
		
	}
}

ClassMethod ComputeCategory(pReasonCode As %String) As %String
{
		Set tCat = $Case(pReasonCode, "Blocked":"Unit Restraint",
									  "Fallen Material":"Performance",
									  "Holiday":"Unavailable",
									  "No Electricity":"Unit Restraint",
									  "No Orders":"Unavailable",
									  "Not Scheduled":"Unavailable",
									  "Starved":"Unit Restraint",
									  :"Fault")
		
		Quit tCat
}

Storage Default
{
<Data name="DowntimeEventsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductionOrder</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>ReasonCode</Value>
</Value>
<Value name="5">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.DowntimeEventsD</DataLocation>
<DefaultData>DowntimeEventsDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.DowntimeEventsD</IdLocation>
<IndexLocation>^IRISDemo.Data.DowntimeEventsI</IndexLocation>
<StreamLocation>^IRISDemo.Data.DowntimeEventsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
