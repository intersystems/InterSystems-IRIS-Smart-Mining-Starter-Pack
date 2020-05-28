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
      <level name="SliceStartDate" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceStartDate1" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceStartDate2" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceStartDate3" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceStartDate4" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Reason" disabled="false" hasAll="false" allCaption="All Reason" allDisplayName="Reason" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Description" disabled="false" sourceProperty="StatusReason.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="StatusType" disabled="false" hasAll="false" allCaption="All Description" allDisplayName="Description" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Description" disabled="false" sourceProperty="StatusReason.StatusType.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="EquipmentCategory" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" displayName="Category" disabled="false" sourceProperty="Equipment.EquipmentCategory.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Name1" displayName="Name" disabled="false" sourceProperty="Equipment.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Shift" disabled="false" hasAll="false" allCaption="All Id" allDisplayName="Id" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Id" disabled="false" sourceProperty="Shift.Id" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="DateTime" disabled="false" sourceProperty="Shift.DateTime" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Name" displayName="Crew Name" disabled="false" sourceProperty="Shift.Crew.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="PartialDuration" disabled="false" sourceProperty="PartialDuration" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <listing name="New_listing1" displayName="Equipment Name" description="Partial Duration" disabled="false" listingType="table" fieldList="Equipment-&gt;Name Equipment, PartialDuration, SliceStartDate, ddbkey, Shift-&gt;DateTime Shift">
  </listing>
  <listing name="New_listing2" disabled="false" listingType="table" fieldList="PartialDuration">
  </listing>
  <listing name="New_listing3" displayName="DDBKEY" disabled="false" listingType="table" fieldList="ddbkey">
  </listing>
</cube>
}

Parameter DOMAIN;

}
