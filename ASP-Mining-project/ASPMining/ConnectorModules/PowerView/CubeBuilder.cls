Include %sySystem

Class ASPMining.ConnectorModules.PowerView.CubeBuilder Extends (IRISDemo.Util.BaseTask, %SYS.Task.Definition)
{

Parameter TaskName = "PowerView Connector Cube Builder";

Method OnTaskExecution() As %Status
{
		Set tSC = $$$OK
		Try
		{
			//set cubeToBuild = "ASPMining.Analytics.EquipmentCube"
			Set tSC = ..buildACube("ASPMining.Analytics.EquipmentCube")
			Set tSC = ..buildACube("ASPMining.Analytics.ProductionEventsCube")
			Set tSC = ..buildACube("ASPMining.Analytics.StatusEventCube")
			Set tSC = ..buildACube("ASPMining.Analytics.StatusEventSlicedCube")
			Set tSC = ..buildACube("ASPMining.Analytics.UnifiedEventsCube")
			//Set tSC = ##class(%DeepSee.Utils).%BuildCube(cubeToBuild)

            Quit:$$$ISERR(tSC)
		}
		Catch(Exception)
		{
			Set tSC = Exception.AsStatus()
		}
		
        If $System.Status.IsError(tSC)
        {
             Do ..LogStatus(tSC, "OnTaskExecution")
        }

		Quit $$$OK // I don't want my task to stop because of an error that may be temporary
}

Method buildACube(pCubeToBuild As %String) As %Status
{
	Do ..Log("Building PowerView Cube: "_pCubeToBuild_"....")
	Set tSC = $System.DeepSee.SynchronizeCube(pCubeToBuild)
    Quit tSC
}

}
