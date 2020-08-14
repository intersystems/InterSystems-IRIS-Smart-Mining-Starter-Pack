/// 
Class ASPMining.Analytics.OEMEventsCube Extends %DeepSee.CubeDefinition [ DependsOn = ASPMining.CanonicalModel.HWMonitoring.OEMEvent, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ASPMining.Analytics.OEMEvents" displayName="OEM Events" disabled="false" abstract="false" sourceClass="ASPMining.CanonicalModel.HWMonitoring.OEMEvent" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Name" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EquipmentName" disabled="false" sourceProperty="Equipment.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H2" disabled="false" hidden="false">
      <level name="EquipmentModel" disabled="false" sourceProperty="Equipment.EquipmentModel.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
    <hierarchy name="H3" disabled="false" hidden="false">
      <level name="EquipmentCategory" disabled="false" sourceProperty="Equipment.EquipmentCategory.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Event" disabled="false" hasAll="false" allCaption="All ReadTime" allDisplayName="ReadTime" sourceProperty="ReadTime" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ReadTime" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Value" disabled="false" sourceProperty="Value" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
</cube>
}

Parameter DOMAIN;

}
