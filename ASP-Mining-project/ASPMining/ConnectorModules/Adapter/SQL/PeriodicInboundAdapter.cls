Class ASPMining.ConnectorModules.Adapter.SQL.PeriodicInboundAdapter Extends EnsLib.SQL.InboundAdapter
{

Parameter SETTINGS = "-RegistryID:Basic,-Query:Data,-Parameters:Data,-DeleteQuery:Data,-KeyFieldName:Data,-JDBCDriver:Connection,-JDBCClasspath:Connection";

/// The connection string for the SQL server 
/// (e.g. <i>jdbc:sqlserver://192.168.0.3:1433</i>)
Property DSN As %String;

/// Setting InitialExpression to "select 1"
Property Query As %String(MAXLEN = "") [ InitialExpression = "select 1", Required ];

/// Setting InitialExpression to ""
Property KeyFieldName As %String;

}
