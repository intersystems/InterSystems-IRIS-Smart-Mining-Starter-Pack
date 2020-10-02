Class ASPMining.ConnectorModules.Adapter.SQL.PeriodicInboundAdapter Extends EnsLib.SQL.InboundAdapter
{

Parameter SETTINGS = "-RegistryID:Basic,-Query:Data,-Parameters:Data,-DeleteQuery:Data,-KeyFieldName:Data,-JDBCDriver:Connection,-JDBCClasspath:Connection,AnonymizeData:Basic,MaxShiftId:Data";

/// The connection string for the SQL server with the source data 
/// (e.g. <i>jdbc:sqlserver://192.168.0.3:1433</i>)
Property DSN As %String;

/// Override Some sensible data with anonymous values
Property AnonymizeData As %Boolean  [ InitialExpression = "true"];

/// Max Shift Id to query. Useful to limit the number of shifts to query to the source database.
Property MaxShiftId As %Integer  [ InitialExpression = "99999"]; //35126 Is the first shift of February 2018

/// Setting InitialExpression to "select 1"
Property Query As %String(MAXLEN = "") [ InitialExpression = "select 1", Required ];

/// Setting InitialExpression to ""
Property KeyFieldName As %String;

}
