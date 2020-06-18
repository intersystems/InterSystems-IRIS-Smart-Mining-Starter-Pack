/// 
Class ASPMining.Analytics.StatusEventSlicedCube Extends %DeepSee.CubeDefinition [ DependsOn = ASPMining.CanonicalModel.Operation.StatusEventSliced, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ASPMining.Analytics.StatusEventSlicedCube" displayName="Status Events Sliced Cube" disabled="false" abstract="false" sourceClass="ASPMining.CanonicalModel.Operation.StatusEventSliced" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="ShiftType" disabled="false" hasAll="false" allCaption="All Type" allDisplayName="Type" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Type" disabled="false" sourceProperty="Shift.ShiftType.Type" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="SliceStartDate" disabled="false" hasAll="false" allCaption="All SliceStartDate" allDisplayName="SliceStartDate" sourceProperty="SliceStartDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="SliceStartDateYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceStartDateMonth" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceStartDateDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceStartDateHour" disabled="true" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceStartDateMinute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Reason" disabled="false" hasAll="false" allCaption="All Reason" allDisplayName="Reason" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Description" disabled="false" sourceProperty="StatusReason.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Equipment" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Category" displayName="Category" disabled="false" sourceProperty="Equipment.EquipmentCategory.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Name" displayName="Name" disabled="false" sourceProperty="Equipment.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ShiftInfo" disabled="false" hasAll="false" allCaption="All Id" allDisplayName="Id" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ShiftId" disabled="false" sourceProperty="Shift.Id" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="ShiftType" disabled="false" sourceProperty="Shift.ShiftType.Type" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H3" disabled="false" hidden="false">
      <level name="CrewName" disabled="false" sourceProperty="Shift.Crew.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ShiftDate" disabled="false" hasAll="false" allCaption="All DateTime" allDisplayName="DateTime" sourceProperty="Shift.DateTime" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="DateTimeYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="DateTimeMonth" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="DateTimeDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="DateTimeMinute" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="StatusType" disabled="false" hasAll="false" allCaption="All StatusType" allDisplayName="StatusType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="StatusType" disabled="false" sourceProperty="StatusType.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="PartialDuration" disabled="false" sourceProperty="PartialDuration" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <listing name="ListingDetails" displayName="Equipment Name" description="Partial Duration" disabled="false" listingType="table" fieldList="Equipment-&gt;Name Equipment, PartialDuration, SliceStartDate, ddbkey, Shift-&gt;DateTime Shift">
  </listing>
</cube>
}

Parameter DOMAIN;

}
