Class IRISDemo.Data.TimeSlice Extends %Persistent
{

Parameter DSTIME = "AUTO";

Property StartTime As %TimeStamp [ Required ];

Property EndTime As %TimeStamp [ Required ];

Property ProductionCounts As ProductionCounts;

Property WasteCounts As WasteCounts;

Property DowntimeEvent As DowntimeEvents;

Property ItemMaster As ItemMaster [ Calculated, SqlComputeCode = { Set {*}=##class(IRISDemo.Data.TimeSlice).ComputeItemMaster({ID})}, SqlComputed ];

Property ProductionOrder As ProductionOrderChange [ Calculated, SqlComputeCode = { Set {*}=##class(IRISDemo.Data.TimeSlice).ComputeProductionOrder({ID})}, SqlComputed ];

ForeignKey ProductionCountsFK(ProductionCounts) References ProductionCounts();

ForeignKey WasteCountsFK(WasteCounts) References WasteCounts();

ForeignKey DowntimeEventFK(DowntimeEvent) References DowntimeEvents();

ForeignKey ItemMasterFK(ItemMaster) References ItemMaster();

ForeignKey ProductionOrderFK(ProductionOrder) References ProductionOrderChange();

Property CalendarTime As %Integer [ Calculated, SqlComputeCode = { 	
		Set {*} = ##class(IRISDemo.Data.TimeSlice).ComputeCalendarTime({StartTime}, {EndTime})
		}, SqlComputed ];

Property FaultTime As %Integer [ Calculated, SqlComputeCode = { 	
		Set {*} = ##class(IRISDemo.Data.TimeSlice).ComputeFaultTime({ID})
		}, SqlComputed ];

Property UnavailableTime As %Integer [ Calculated, SqlComputeCode = { 	
		Set {*} = ##class(IRISDemo.Data.TimeSlice).ComputeUnavailableTime({ID})
		}, SqlComputed ];

Property OutsideAreaTime As %Integer [ Calculated, SqlComputeCode = { 	
		Set {*} = ##class(IRISDemo.Data.TimeSlice).ComputeOutsideAreaTime({ID})
		}, SqlComputed ];

Index DowntimeEventIndex On DowntimeEvent;

ClassMethod ComputeFaultTime(pID As %String) As %Integer
{
		Set obj = ..%OpenId(pID)
		Set iDuration=0

		If (obj.DowntimeEvent'="") && (obj.DowntimeEvent.ReasonCategory="Fault")
		{
			Set iDuration=$System.SQL.DATEDIFF("ss", obj.StartTime, obj.EndTime)
		}
		
		Quit iDuration
}

ClassMethod ComputeOutsideAreaTime(pID As %String) As %Integer
{
		Set obj = ..%OpenId(pID)
		Set iDuration=0

		If (obj.DowntimeEvent'="") && (obj.DowntimeEvent.ReasonCategory="Unit Restraint")
		{
			Set iDuration=$System.SQL.DATEDIFF("ss", obj.StartTime, obj.EndTime)
		}
		
		Quit iDuration
}

ClassMethod ComputeCalendarTime(pStartDate As %TimeStamp, pEndDate As %TimeStamp) As %Integer
{
		Set iDuration=$System.SQL.DATEDIFF("ss", pStartDate, pEndDate)
		
		Quit iDuration
}

ClassMethod ComputeUnavailableTime(pID As %String) As %Integer
{
		Set obj = ..%OpenId(pID)
		Set iDuration=0

		If (obj.DowntimeEvent'="") && (obj.DowntimeEvent.ReasonCategory="Unavailable")
		{
			Set iDuration=$System.SQL.DATEDIFF("ss", obj.StartTime, obj.EndTime)
		}
		
		Quit iDuration
}

ClassMethod ComputeItemMaster(pID As %String) As %Integer
{
		Set obj = ..%OpenId(pID)
		If obj.ProductionCounts'="" Quit obj.ProductionCounts.ProductionOrder.ItemMaster.%Id()
		If obj.WasteCounts'="" Quit obj.WasteCounts.ProductionOrder.ItemMaster.%Id()
		If obj.DowntimeEvent'="" Quit obj.DowntimeEvent.ProductionOrder.ItemMaster.%Id()
		
		Quit ""
}

ClassMethod ComputeProductionOrder(pID As %String) As %Integer
{
		Set obj = ..%OpenId(pID)
		If obj.ProductionCounts'="" Quit obj.ProductionCounts.ProductionOrder.%Id()
		If obj.WasteCounts'="" Quit obj.WasteCounts.ProductionOrder.%Id()
		If obj.DowntimeEvent'="" Quit obj.DowntimeEvent.ProductionOrder.%Id()
		
		Quit ""
}

Storage Default
{
<Data name="TimeSliceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StartTime</Value>
</Value>
<Value name="3">
<Value>EndTime</Value>
</Value>
<Value name="4">
<Value>ProductionCounts</Value>
</Value>
<Value name="5">
<Value>WasteCounts</Value>
</Value>
<Value name="6">
<Value>DowntimeEvent</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.TimeSliceD</DataLocation>
<DefaultData>TimeSliceDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.TimeSliceD</IdLocation>
<IndexLocation>^IRISDemo.Data.TimeSliceI</IndexLocation>
<StreamLocation>^IRISDemo.Data.TimeSliceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
