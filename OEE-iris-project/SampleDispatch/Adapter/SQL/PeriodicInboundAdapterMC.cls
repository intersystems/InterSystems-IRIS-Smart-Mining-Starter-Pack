Class SampleDispatch.Adapter.SQL.PeriodicInboundAdapterMC Extends EnsLib.SQL.InboundAdapter
{
	/// Hiding parameters
	//Parameter SETTINGS = "-Query:Data,-Parameters:Data,-DeleteQuery:Data,-KeyFieldName:Data";
	/// Setting InitialExpression to "select 1"
	Property Query As %String(MAXLEN = "") [ Required, InitialExpression = "select 1" ];
	
	/// Setting InitialExpression to ""
	Property KeyFieldName As %String [ InitialExpression = "" ];
	
}