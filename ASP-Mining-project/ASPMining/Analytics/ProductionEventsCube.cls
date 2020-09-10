/// Production Events
Class ASPMining.Analytics.ProductionEventsCube Extends %DeepSee.CubeDefinition [ DependsOn = ASPMining.CanonicalModel.Production.ProductionEvent, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ASPMining.Analytics.ProductionEventsCube" displayName="Production Events Cube" description="Production Events" disabled="false" abstract="false" sourceClass="ASPMining.CanonicalModel.Production.ProductionEvent" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="StartTime" disabled="false" hasAll="false" allCaption="All StartTime" allDisplayName="StartTime" sourceProperty="StartTime" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="StartTimeDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartTimeHour" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="StartTimeMinute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Shift" disabled="false" hasAll="false" allCaption="All Shift" allDisplayName="Shift" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Id" disabled="false" sourceProperty="Shift.Id" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="Type" disabled="false" sourceProperty="Shift.ShiftType.Type" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ProductionStatus" disabled="false" hasAll="false" allCaption="All Description" allDisplayName="Description" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Description" disabled="false" sourceProperty="ProductionStatusType.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="PreviousLocation" disabled="false" hasAll="false" allCaption="All PreviousLocation" allDisplayName="PreviousLocation" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" disabled="false" sourceProperty="PreviousLocation.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="Grade" disabled="false" sourceProperty="PreviousLocation.Grade" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Location" disabled="false" hasAll="false" allCaption="All Location" allDisplayName="Location" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" disabled="false" sourceProperty="Location.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="Grade" disabled="false" sourceProperty="Location.Grade" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Equipment" disabled="false" hasAll="false" allCaption="All Equipment" allDisplayName="Equipment" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="Category" disabled="false" sourceProperty="Equipment.EquipmentCategory.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" disabled="false" sourceProperty="Equipment.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H3" disabled="false" hidden="false">
      <level name="Model" disabled="false" sourceProperty="Equipment.EquipmentModel.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Duration" disabled="false" sourceProperty="Duration" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="MeasuredTons" disabled="false" sourceProperty="MeasuredTons" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="Capacity" disabled="false" sourceProperty="Equipment.Capacity" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
</cube>
}

Parameter DOMAIN;

}
