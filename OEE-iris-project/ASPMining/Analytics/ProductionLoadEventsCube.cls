/// 
Class ASPMining.Analytics.ProductionLoadEventsCube Extends %DeepSee.CubeDefinition [ DependsOn = ASPMining.CanonicalModel.Production.LoadEvent, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ProductionLoadEventsCube" displayName="ProductionLoadEventsCube" disabled="false" abstract="false" sourceClass="ASPMining.CanonicalModel.Production.LoadEvent" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Time" disabled="false" hasAll="false" allCaption="All TimeArrive" allDisplayName="TimeArrive" sourceProperty="TimeArrive" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TimeArriveYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="TimeArriveMonth" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="TimeArriveDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="TimeArriveHour" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="TimeArriveMinute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="TimeFullMinute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H3" disabled="false" hidden="false">
      <level name="TimeLoadMinute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Truck" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" disabled="false" sourceProperty="EquipmentTruck.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="Category" disabled="false" sourceProperty="EquipmentTruck.EquipmentCategory.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Excav" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" disabled="false" sourceProperty="EquipmentExcav.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="Category" disabled="false" sourceProperty="EquipmentExcav.EquipmentCategory.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ShiftDate" disabled="false" hasAll="false" allCaption="All DateTime" allDisplayName="DateTime" sourceProperty="Shift.DateTime" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ShiftDate" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ShiftType" disabled="false" hasAll="false" allCaption="All Type" allDisplayName="Type" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Type" disabled="false" sourceProperty="Shift.ShiftType.Type" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="MeasuredTons" disabled="false" sourceProperty="MeasuredTons" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
</cube>
}

Parameter DOMAIN;

}
