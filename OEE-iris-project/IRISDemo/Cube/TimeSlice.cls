/// 
Class IRISDemo.Cube.TimeSlice Extends %DeepSee.CubeDefinition [ DependsOn = IRISDemo.Data.TimeSlice, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="TimeSlice" displayName="TimeSlice" disabled="false" abstract="false" sourceClass="IRISDemo.Data.TimeSlice" countMeasureName="%COUNT" countMeasureCaption="Number of Timeslice records" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="StartTime" disabled="false" hasAll="false" allCaption="All StartTime" allDisplayName="StartTime" sourceProperty="StartTime" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="StartMonth" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartDate" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartHour" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ItemCode" disabled="false" hasAll="false" allCaption="All ItemCode" allDisplayName="ItemCode" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ItemCode" disabled="false" sourceProperty="ItemMaster.ItemCode" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ProductionOrder" disabled="false" hasAll="false" allCaption="All ProductionOrder" allDisplayName="ProductionOrder" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ProductionOrder" disabled="false" sourceProperty="ProductionOrder.ProductionOrder" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Downtime" disabled="false" hasAll="false" allCaption="All ReasonCategory" allDisplayName="ReasonCategory" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ReasonCategory" disabled="false" sourceProperty="DowntimeEvent.ReasonCategory" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="ReasonCode" disabled="false" sourceProperty="DowntimeEvent.ReasonCode" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="WasteCount" disabled="false" sourceProperty="WasteCounts.WasteCount" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="ProductionCount" disabled="false" sourceProperty="ProductionCounts.ProductionCount" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="FaultTime" disabled="false" sourceProperty="FaultTime" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="UnavailableTime" disabled="false" sourceProperty="UnavailableTime" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="OutsideAreaTime" disabled="false" sourceProperty="OutsideAreaTime" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="CalendarTime" disabled="false" sourceProperty="CalendarTime" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="ItemRate" disabled="false" sourceProperty="ItemMaster.ItemRate" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <calculatedMember name="OperatingTime" disabled="false" dimension="Measures" valueExpression="[Measures].[LoadedTime] - [Measures].[FaultTime]" hidden="false">
  </calculatedMember>
  <calculatedMember name="Availability" disabled="false" dimension="Measures" valueExpression="([Measures].[OperatingTime]/[Measures].[LoadedTime])" formatString="##.##%" hidden="false">
  </calculatedMember>
  <calculatedMember name="LoadedTime" disabled="false" dimension="Measures" valueExpression="[Measures].[CalendarTime] - [Measures].[UnavailableTime] - [Measures].[OutsideAreaTime]" hidden="false">
  </calculatedMember>
  <calculatedMember name="Quality" disabled="false" dimension="Measures" valueExpression="([Measures].[ProductionCount]/( [Measures].[ProductionCount] +  [Measures].[WasteCount]))" formatString="##.##%" hidden="false">
  </calculatedMember>
  <listing name="Availability Details" disabled="false" listingType="table" fieldList="StartTime,EndTime,FaultTime,CalendarTime,OutsideAreaTime,UnavailableTime" orderBy="StartTime ASC">
  </listing>
</cube>
}

Parameter DOMAIN;

}
