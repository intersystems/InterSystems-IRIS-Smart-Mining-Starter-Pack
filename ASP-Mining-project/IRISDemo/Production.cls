Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Java Gateway Service" Category="Datalake" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
    <Item Name="MineCare SQL Event Service" Category="" ClassName="ASPMining.ConnectorModules.MineCare.Service" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="URL">jdbc:sqlserver://192.168.0.3:1433</Setting>
    <Setting Target="Adapter" Name="Credentials">PowerViewCredentials</Setting>
    <Setting Target="Adapter" Name="JGService">Java Gateway Service</Setting>
    <Setting Target="Adapter" Name="Parameters"></Setting>
    <Setting Target="Adapter" Name="Query">SELECT TOP 1 * from dbo.OemEventValue </Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.microsoft.sqlserver.jdbc.SQLServerDriver</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/tmp/mssql-jdbc-7.4.1.jre8.jar</Setting>
    <Setting Target="Adapter" Name="ConnectionAttributes">databaseName=MineCare;user=iris;password=oee;</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
  </Item>
  <Item Name="PowerView SQL Event Service" Category="" ClassName="ASPMining.ConnectorModules.PowerView.Service" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="URL">jdbc:sqlserver://192.168.0.3:1433</Setting>
    <Setting Target="Adapter" Name="Credentials">PowerViewCredentials</Setting>
    <Setting Target="Adapter" Name="JGService">Java Gateway Service</Setting>
    <Setting Target="Adapter" Name="Parameters"></Setting>
    <Setting Target="Adapter" Name="Query">SELECT TOP 1 * from dbo.hist_statusevents</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.microsoft.sqlserver.jdbc.SQLServerDriver</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/tmp/mssql-jdbc-7.4.1.jre8.jar</Setting>
    <Setting Target="Adapter" Name="ConnectionAttributes">databaseName=PowerViewCH;user=iris;password=oee;</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
  </Item>
  <Item Name="PowerView Operation" Category="" ClassName="ASPMining.ConnectorModules.PowerView.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="MineCare Operation" Category="" ClassName="ASPMining.ConnectorModules.MineCare.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
