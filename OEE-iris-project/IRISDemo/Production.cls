Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="PMML File Loader" Category="" ClassName="ML.PMML.BS.Loader.File.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/common_shared/pmml/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.pmml</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/common_shared/imported_pmml/</Setting>
  </Item>
  <Item Name="Java Gateway Service" Category="Datalake" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Sample Dispatch Event Service" Category="" ClassName="SampleDispatch.BS.Event.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">jdbc:IRIS://localhost:51773/APPINT</Setting>
    <Setting Target="Adapter" Name="Credentials">SampleDispatch</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.intersystems.jdbc.IRISDriver</Setting>
    <Setting Target="Adapter" Name="JGService">Java Gateway Service</Setting>
    <Setting Target="Adapter" Name="Parameters"></Setting>
    <Setting Target="Adapter" Name="Query">select 1</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
  </Item>
  <Item Name="Sample Dispatch Event Operation" Category="" ClassName="SampleDispatch.BO.Event.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
