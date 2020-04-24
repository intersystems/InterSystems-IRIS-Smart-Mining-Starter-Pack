Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{

/// This method will create an Interoperability credential meant to be used on Interoperability Productions.
/// It will use the standard SuperUser/sys password for demos.
ClassMethod CreateCredentials(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		Set tNS=$Namespace
		ZN pNamespace
		
		Set tSC = ##class(Ens.Config.Credentials).SetCredential("SampleDispatch", "SuperUser", "sys", 1)
		Set tSC2 = ##class(Ens.Config.Credentials).SetCredential("MineCareCredentials", "SA", "Minecare1", 1)
		Set tSC3 = ##class(Ens.Config.Credentials).SetCredential("PowerViewCredentials", "iris", "oee", 1)
		Quit:$System.Status.IsError(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN tNS
	
	Quit tSC 
}

ClassMethod LoadTransactionalData(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN pNamespace
				
		//Do ##class(IRISDemo.Data.Utils).LoadData()
		
		Do ##class(SampleDispatch.Utils).LoadEverything()
		
		/// All possible events that were triggered when we loaded the demo data
		/// must be deleted. 
		//Kill ^IRISDemo.BS.AppTrigger.Service
		
		/// The production will be started automatically when this image is started as a normal container.
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN "%SYS"
	
	Quit tSC 
}

ClassMethod BuildCubeAndEnableCubeRegistry(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN pNamespace
			
		Set tSC = ##class(%DeepSee.CubeManager.Utils).SetActiveRegistry("OEE.Cube.Registry", 1)
		Quit:$$$ISERR(tSC)
		
		Set tSC = ##class(%DeepSee.CubeManager.Utils).BuildAllRegisteredGroups()
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN "%SYS"
	
	Quit tSC 
}

/// You can customize this to run code during docker build
XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
	<Namespace Name="${Namespace}" Create="no"> 
		<IfDef Var="SourceDir">
            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
            <Import File="${SourceDir}" Recurse="true"/>
            
			<Log Text="Creating Task to save IRIS Analytic files to external volume..." Level="0"/>
			<Invoke Class="IRISAnalytics.Task.SaveFiles" Method="Create" CheckStatus="true"/>

        </IfDef>
                
	</Namespace>
	
	<Log Text="Loading transactional data..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="LoadTransactionalData" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
	<Log Text="Creating credentials..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="CreateCredentials" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
	<Log Text="Building cube and enabling cube registry..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="BuildCubeAndEnableCubeRegistry" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
</Manifest>
}
}