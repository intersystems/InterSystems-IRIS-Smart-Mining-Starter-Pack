/// 
Class ASPMining.Analytics.EquipmentCube Extends %DeepSee.CubeDefinition [ DependsOn = ASPMining.CanonicalModel.Equipment.Equipment, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ASPMining.Analytics.EquipmentCube" displayName="Equipment Cube" disabled="false" abstract="false" sourceClass="ASPMining.CanonicalModel.Equipment.Equipment" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Equipment" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="CategoryName" displayName="Group Name" disabled="false" sourceProperty="EquipmentCategory.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="EquipmentName" displayName="Equipment Name" disabled="false" sourceProperty="Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Model" disabled="false" hasAll="false" allCaption="All Model" allDisplayName="Model" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Model" displayName="Equipment Model" disabled="false" sourceProperty="EquipmentModel.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="LastActivity" disabled="false" hasAll="false" allCaption="All EventDateTime" allDisplayName="EventDateTime" sourceProperty="LastUnifiedEvent.EventDateTime" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EventDateDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="EventDateHour" disabled="false" timeFunction="HourNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="EventDateMinute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Capacity" disabled="false" sourceProperty="Capacity" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <measure name="LastActivity" disabled="false" sourceProperty="LastUnifiedEvent.EventDateTime" aggregate="MAX" type="date" hidden="false" searchable="false">
  </measure>
</cube>
}

Parameter DOMAIN;

}
