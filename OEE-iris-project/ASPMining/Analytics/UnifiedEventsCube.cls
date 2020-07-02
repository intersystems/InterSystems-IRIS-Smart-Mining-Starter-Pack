/// Cube for unified production and operatin events
Class ASPMining.Analytics.UnifiedEventsCube Extends %DeepSee.CubeDefinition [ DependsOn = ASPMining.CanonicalModel.Operation.UnifiedEvents, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="UnifiedEventsCube" displayName="UnifiedEventsCube" description="Cube for unified production and operatin events" disabled="false" abstract="false" sourceClass="ASPMining.CanonicalModel.Operation.UnifiedEvents" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Equipment" disabled="false" hasAll="false" allCaption="All Equipment" allDisplayName="Equipment" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EquipmentCategory" disabled="false" sourceProperty="Equipment.EquipmentCategory" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="EquipmentName" disabled="false" sourceProperty="Equipment.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ShiftType" disabled="false" hasAll="false" allCaption="All ShiftType" allDisplayName="ShiftType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Type" disabled="false" sourceProperty="Shift.ShiftType.Type" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Id" disabled="false" sourceProperty="Shift.Id" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="EventDateTime" disabled="false" hasAll="false" allCaption="All EventDateTime" allDisplayName="EventDateTime" sourceProperty="EventDateTime" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EventDateTimeYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="EventDateTimeMonth" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="EventDateTimeDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="EventDateTimeHour" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="EventDateTimeMinute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="StatusEvent" disabled="false" hasAll="false" allCaption="All StatusEvent" allDisplayName="StatusEvent" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="StatusReason" disabled="false" sourceProperty="StatusEvent.StatusReason.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="StatusTypeInsideReason" disabled="false" sourceProperty="StatusEvent.StatusReason.StatusType.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H3" disabled="false" hidden="false">
      <level name="StatusType" disabled="false" sourceProperty="StatusEvent.StatusType" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ProductionEvent" disabled="false" hasAll="false" allCaption="All ProductionEvent" allDisplayName="ProductionEvent" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ProductionStatusType" disabled="false" sourceProperty="ProductionEvent.ProductionStatusType.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Location" disabled="false" hasAll="false" allCaption="All Location" allDisplayName="Location" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="LocationName" disabled="false" sourceProperty="ProductionEvent.Location.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PreviousLocation" disabled="false" hasAll="false" allCaption="All PreviousLocation" allDisplayName="PreviousLocation" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="PreviousLocationName" disabled="false" sourceProperty="ProductionEvent.PreviousLocation.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Crew" disabled="false" hasAll="false" allCaption="All Crew" allDisplayName="Crew" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="CrewName" disabled="false" sourceProperty="Shift.Crew" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ShiftDateTime" disabled="false" hasAll="false" allCaption="All DateTime" allDisplayName="DateTime" sourceProperty="Shift.DateTime" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ShiftDateTimeDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="ShiftDateTimeHour" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ProductionEventStartTime" disabled="false" hasAll="false" allCaption="All StartTime" allDisplayName="StartTime" sourceProperty="ProductionEvent.StartTime" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ProductionEventStartTimeDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="ProductionEventStartTimeMinute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="StatusEventStartDate" disabled="false" hasAll="false" allCaption="All StartDate" allDisplayName="StartDate" sourceProperty="StatusEvent.StartDate" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="StatusEventStartDateDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StatusEventStartDateMinute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="UnifiedEventDuration" disabled="false" sourceProperty="Duration" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="MeasuredTons" disabled="false" sourceProperty="ProductionEvent.MeasuredTons" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="StatusEventDuration" disabled="false" sourceProperty="StatusEvent.Duration" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <listing name="Listado1" disabled="false" listingType="table" fieldList="Id, Duration, ProductionEvent-&gt;Duration as LastProductionEventDuration,StatusEvent-&gt;Duration as LastStatusEventDuration, Equipment-&gt;Id as Equipment, EventDateTime, ProductionEvent-&gt;ProductionStatusType-&gt;Description as ProductionStatus, ProductionEvent-&gt;Location-&gt;Name as Location, ProductionEvent-&gt;PreviousLocation-&gt;Name as PreviousLocation, Shift-&gt;Id as Shift, StatusEvent-&gt;StatusType-&gt;Description as OperationalStatus, StatusEvent-&gt;StatusReason-&gt;Description as OperationalStatus,
ProductionEvent-&gt;MeasuredTons as MeasuredTons,
Equipment-&gt;Capacity as EquipmentCapacity,
cast(ProductionEvent-&gt;MeasuredTons/Equipment-&gt;Capacity*100 as int) as LoadFactor">
  </listing>
</cube>
}

Parameter DOMAIN;

}
