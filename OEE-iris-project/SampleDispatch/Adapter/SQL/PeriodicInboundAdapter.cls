/// This is a periodic SQL adapter. It has a fixed query string that will just "select 1" every call interval which
/// will trigger ProcessInput. The idea is that OnProcessInput will now run the queries we want to run.
/// This adapter will hide parameters that we don't want people to change such as Query, Parameters, DeleteQuery and KeyFieldName
Class SampleDispatch.Adapter.SQL.PeriodicInboundAdapter Extends EnsLib.SQL.InboundAdapter
{
	/// Hiding parameters
	Parameter SETTINGS = "-Query:Data,-Parameters:Data,-DeleteQuery:Data,-KeyFieldName:Data";
	/// Setting InitialExpression to "select 1"
	Property Query As %String(MAXLEN = "") [ Required, InitialExpression = "select 1" ];
	
	/// Setting InitialExpression to ""
	Property KeyFieldName As %String [ InitialExpression = "" ];
	
}