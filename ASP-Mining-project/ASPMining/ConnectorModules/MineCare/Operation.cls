Include DEMOMACROS

Class ASPMining.ConnectorModules.MineCare.Operation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method NewEquipment(pInput As ASPMining.CanonicalModel.Equipment.Equipment, Output pOutput As Ens.Response) As %Status
{

	Set sc=$$$OK
	
	Try
	{		
		If '##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexExists(pInput.Id) {
			Set sc = pInput.%Save()		
		}
	}
	Catch (oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

Method NewCategory(pInput As ASPMining.CanonicalModel.Equipment.EquipmentCategory, Output pOutput As Ens.Response) As %Status
{

	Set sc=$$$OK
	
	Try
	{		
		If '##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).EquipmentCategoryIndexExists(pInput.Name) {
			Set sc = pInput.%Save()
		}
	}
	Catch (oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

Method NewModel(pInput As ASPMining.CanonicalModel.Equipment.EquipmentModel, Output pOutput As Ens.Response) As %Status
{

	Set sc=$$$OK
	
	Try
	{		
		If '##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).EquipmentModelIndexExists(pInput.Model) {
			Set sc = pInput.%Save()
		}
	}
	Catch (oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

Method NewShift(pInput As ASPMining.CanonicalModel.Planning.Shift, Output pOutput As Ens.Response) As %Status
{

	Set sc=$$$OK
	
	Try
	{		
		If '##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(pInput.Id) {
			Set sc = pInput.%Save()
		}
	}
	Catch (oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

Method NewOEMEvent(pInput As ASPMining.CanonicalModel.HWMonitoring.OEMEvent, Output pOutput As Ens.Response) As %Status
{

	Set sc=$$$OK
	
	Try
	{		
		If '##class(ASPMining.CanonicalModel.HWMonitoring.OEMEvent).OEMEventIndexExists(pInput.Id) {
			Set sc = pInput.%Save()
		}
	}
	Catch (oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="ASPMining.CanonicalModel.Equipment.Equipment">
        <Method>NewEquipment</Method>
    </MapItem>
    <MapItem MessageType="ASPMining.CanonicalModel.Equipment.EquipmentCategory">
        <Method>NewCategory</Method>
    </MapItem>
    <MapItem MessageType="ASPMining.CanonicalModel.Equipment.EquipmentModel">
        <Method>NewModel</Method>
    </MapItem>
    <MapItem MessageType="ASPMining.CanonicalModel.Planning.Shift">
        <Method>NewShift</Method>
    </MapItem>
    <MapItem MessageType="ASPMining.CanonicalModel.HWMonitoring.OEMEvent">
        <Method>NewOEMEvent</Method>
    </MapItem>
</MapItems>
}

}
