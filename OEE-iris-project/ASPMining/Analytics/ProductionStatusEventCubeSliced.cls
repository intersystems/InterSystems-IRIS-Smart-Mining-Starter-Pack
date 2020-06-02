/// Production status sliced time windows for production tracking
Class ASPMining.Analytics.ProductionStatusEventCubeSliced Extends %DeepSee.CubeDefinition [ DependsOn = ASPMining.CanonicalModel.Production.ProductionEventSliced, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ProductionStatusEventCubeSliced" displayName="ProductionStatusEventCubeSliced" description="Production status sliced time windows for production tracking" disabled="false" abstract="false" sourceClass="ASPMining.CanonicalModel.Production.ProductionEventSliced" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="SliceStartDate" disabled="false" hasAll="false" allCaption="All SliceStartDate" allDisplayName="SliceStartDate" sourceProperty="SliceStartDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="SliceYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceMonth" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceDay" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="SliceMinute" disabled="false" timeFunction="MinuteNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Id" disabled="false" hasAll="false" allCaption="All Id" allDisplayName="Id" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Id" displayName="ShiftId" disabled="false" sourceProperty="Shift.Id" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Name" disabled="false" hasAll="false" allCaption="All Name" allDisplayName="Name" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EquipmentCategory" displayName="Equipment Category" disabled="false" sourceProperty="EquipmentTruck.EquipmentCategory.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="EquipmentName" disabled="false" sourceProperty="EquipmentTruck.Name" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Description" disabled="false" hasAll="false" allCaption="All Description" allDisplayName="Description" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Description" displayName="Production Status Type" disabled="false" sourceProperty="ProductionStatusType.Description" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="PartialDuration" disabled="false" sourceProperty="PartialDuration" aggregate="SUM" type="number" hidden="false" searchable="false">
  </measure>
  <listing name="New_listing1" disabled="false" listingType="table" fieldList="SliceStartDate,ddbkey,ProductionStatusType-&gt;Description,ProductionStatusType-&gt;Type,EquipmentTruck-&gt;Name AS &quot;Camion&quot;,EquipmentExcav-&gt;Name AS &quot;Excav&quot;,PartialDuration,MeasuredTons,EventStartDate">
  </listing>
</cube>
}

Parameter DOMAIN;

}
