/// 
Class OEE.Cube.MiningOEE Extends %DeepSee.CubeDefinition [ DependsOn = OEE.Data.OEETimeSlice, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="MiningOEE" displayName="Mining OEE" disabled="false" abstract="false" sourceClass="OEE.Data.OEETimeSlice" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="StartTime" disabled="false" hasAll="false" allCaption="All StartTime" allDisplayName="StartTime" sourceProperty="StartTime" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="StartTimeMonth" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartTimeDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartTimeHour" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Equipment" disabled="false" hasAll="false" allCaption="All Equipment" allDisplayName="Equipment" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Equipment" disabled="false" sourceProperty="Equipment" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Tons" disabled="false" sourceProperty="Dump.Tons" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="IdleTime" disabled="false" sourceProperty="IdleTime" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="DumpTime" disabled="false" sourceProperty="DumpTime" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="DowntimeTime" disabled="false" sourceProperty="DowntimeTime" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="DelayTime" disabled="false" sourceProperty="DelayTime" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="TotalTime" disabled="false" sourceProperty="TotalTime" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <calculatedMember name="OperatingTime" disabled="false" dimension="Measures" valueExpression="[MEASURES].[AVAILABLETIME]- [Measures].[IdleTime]" hidden="false">
  </calculatedMember>
  <calculatedMember name="OEE" disabled="false" dimension="Measures" valueExpression="[MEASURES].[PRODUCTION EFFICENCY]* [MEASURES].[AVAILABILITY]* [MEASURES].[UTILIZATION]" formatString="#.##%;;;;" hidden="false">
  </calculatedMember>
  <calculatedMember name="Production Efficency" disabled="false" dimension="Measures" valueExpression="[Measures].[Tons]/( [MEASURES].[OPERATINGTIME]*0.13)" formatString="##.##%" hidden="false">
  </calculatedMember>
  <calculatedMember name="Utilization" disabled="false" dimension="Measures" valueExpression="[MEASURES].[OPERATINGTIME]/ [MEASURES].[AVAILABLETIME]" formatString="##.##%" hidden="false">
  </calculatedMember>
  <calculatedMember name="Availability" disabled="false" dimension="Measures" valueExpression="[MEASURES].[AVAILABLETIME]/ [Measures].[TotalTime]" formatString="##.##%" hidden="false">
  </calculatedMember>
  <calculatedMember name="AvailableTime" disabled="false" dimension="Measures" valueExpression="[Measures].[TotalTime]- [Measures].[DowntimeTime]" hidden="false">
  </calculatedMember>
  <listing name="Detail" disabled="false" listingType="table" fieldList="StartTime,EndTime,Equipment,Dump-&gt;Tons">
  </listing>
</cube>
}

Parameter DOMAIN;

}
