Include %sySystem

Class IRISAnalytics.Task.SaveFiles Extends (IRISDemo.Util.BaseTask, %SYS.Task.Definition)
{
	Parameter TaskName = "Save IRIS Analytics Pivots and Dashboards to external volume";
	
	Property Folder As %String [ InitialExpression = "/tmp/iris-analytics" ];
		
	Method OnTaskExecution() As %Status
	{
		Set tSC = $$$OK
		Try
		{
			Set tFile = ##class(%File).NormalizeFilename("iris-analytics-artifacts.xml", ..Folder)
			
            Do ..Log("Saving IRIS analytics files to "_tFile)
            Set tSC=$system.OBJ.Export("*.DFI", tFile)
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
}