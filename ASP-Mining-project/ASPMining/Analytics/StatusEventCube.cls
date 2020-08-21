/// 
Class ASPMining.Analytics.StatusEventCube Extends %DeepSee.CubeDefinition [ DependsOn = ASPMining.CanonicalModel.Operation.StatusEvent, ProcedureBlock ]
{

Parameter DSTIME = "AUTO";

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ASPMining.Analytics.StatusEventCube" displayName="Status Event Cube" disabled="false" abstract="false" sourceClass="ASPMining.CanonicalModel.Operation.StatusEvent" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Equipment" disabled="false" hasAll="false" allCaption="All Equipment" allDisplayName="Equipment" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" displayName="Equipment Group" disabled="false" sourceProperty="Equipment.EquipmentCategory.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Name2" displayName="Equipment Name" disabled="false" sourceProperty="Equipment.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="Model" displayName="Equipment Model" disabled="false" sourceProperty="Equipment.EquipmentModel.Model" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="StatusType" disabled="false" hasAll="false" allCaption="All StatusType" allDisplayName="StatusType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Description" displayName="Status Type" disabled="false" sourceProperty="StatusReason.StatusType.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Description1" displayName="Reason" disabled="false" sourceProperty="StatusReason.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="StatusType" disabled="false" sourceProperty="StatusType.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="StartDate" disabled="false" hasAll="false" allCaption="All StartDate" allDisplayName="StartDate" sourceProperty="StartDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="StartDate" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartDate1" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartDate2" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartDate3" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartDate4" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Id" disabled="false" hasAll="false" allCaption="All Id" allDisplayName="Id" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Id" disabled="false" sourceProperty="Shift.Id" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Duration" disabled="false" sourceProperty="Duration" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <listing name="New_listing1" disabled="false" listingType="table" fieldList="StartDate, Duration, StatusType-&gt;Description, StatusReason-&gt;Reason, StatusReason-&gt;StatusType-&gt;Description">
  </listing>
</cube>
}

Parameter DOMAIN;

}
