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
		Set tSC4 = ##class(Ens.Config.Credentials).SetCredential("IrisOpcUaDemo", "SuperUser", "sys", 1)
		Quit:$System.Status.IsError(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN tNS
	
	Quit tSC
}

ClassMethod BuildCubeAndEnableCubeRegistry(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN pNamespace
		Set tSC = ##class(%DeepSee.CubeManager.Utils).SetActiveRegistry("ASPMining.Analytics.CubeRegistry", 1)
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

ClassMethod InstallMDX2JSON(pNamespace As %String, pSetupDir As %String, pUser As %String, pPass As %String, pImport As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN "APPINT"
			
		Set pVars("User")=pUser
		Set pVars("Password")=pPass
		Set pVars("Namespace")=pNamespace
		Set pVars("Import")=pImport
		Set pVars("SourceDir")=pSetupDir
		
		Set tSC = ##class(MDX2JSON.Installer).setup(.pVars)
		Quit:$$$ISERR(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN "%SYS"
	
	Quit tSC
}

ClassMethod EnableIAM(pPass As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN "%SYS"
		// set iam User pass to pPass
		// set iam User Enabled
		// set iam Application enabled
		
		//Set tSC = ##class(MDX2JSON.Installer).setup(.pVars)
		Quit:$$$ISERR(tSC)
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN "%SYS"
	
	Quit tSC
}

ClassMethod DisableJournalForDatabase(pDatabaseName As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tSC = ##class(Config.Databases).Get(pDatabaseName,.v)
		Quit:$$$ISERR(tSC)

		Set tDatabaseDir = v("/usr/irissys/mgr/journal/")

		Set db=##Class(SYS.Database).%OpenId(tDatabaseDir)

		Set db.GlobalJournalState=2

		Set tSC = db.%Save()
	} Catch (oException)
	{
		Set tSC = oException.AsStatus()
	} 
	Quit tSC
}

ClassMethod LoadConnectorAndDemos(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		Set tNS=$Namespace
		ZN pNamespace

		If (##class(%Dictionary.CompiledClass).%ExistsId("OPCUA.Utils")){
			set tSC = ##class(OPCUA.Utils).Install("/usr/irissys/bin/irisopcua.so")	
			//Do ##class(Examples.OPCUADS.Utils).LoadOnInstallation()
		}
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN tNS
	
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
		
		
	<Log Text="Creating credentials..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="CreateCredentials" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
	<!--
	<Log Text="Building cube and enabling cube registry..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="BuildCubeAndEnableCubeRegistry" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	-->
	
	<Log Text="Installing MDX2JSON..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="InstallMDX2JSON" CheckStatus="true">
		<Arg name="pNamespace" Value="MDX2JSON"/>
		<Arg name="pSetupDir" Value="${SourceDir}MDX2JSON"/>
		<Arg name="pUser" Value="MDXuser"/>
		<Arg name="pPass" Value="sys"/>
		<Arg name="pImport" Value="1"/>
	</Invoke>

	<Log Text="Enabling IAM..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="EnableIAM" CheckStatus="true">
		<Arg name="pPass" Value="sys"/>
	</Invoke>

	<Log Text="Loading Connectors and Demos (OPCUA)..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="LoadConnectorAndDemos" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>

	<!--
	<Invoke	Class="IRISConfig.Installer" Method="DisableJournalForDatabase"	CheckStatus="true">
		<Arg name="pDatabaseName"	Value="journal"/>
	</Invoke>
	
	<Log Text="Building cube and enabling cube registry..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="BuildCubeAndEnableCubeRegistry" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>
	
	-->
	
</Manifest>
}

}
