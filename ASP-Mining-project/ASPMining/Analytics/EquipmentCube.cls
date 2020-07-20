/// 
Class ASPMining.Analytics.EquipmentCube Extends %DeepSee.CubeDefinition [ DependsOn = ASPMining.CanonicalModel.Equipment.Equipment, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ASPMining.Analytics.EquipmentCube" displayName="Equipment Cube" disabled="false" abstract="false" sourceClass="ASPMining.CanonicalModel.Equipment.Equipment" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Name" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Name" displayName="Group Name" disabled="false" sourceProperty="EquipmentCategory.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Name1" displayName="Equipment Name" disabled="false" sourceProperty="Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Model" disabled="false" hasAll="false" allCaption="All Model" allDisplayName="Model" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Model" disabled="false" sourceProperty="EquipmentModel.Model" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Capacity" disabled="false" sourceProperty="Capacity" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
</cube>
}

Parameter DOMAIN;

}
