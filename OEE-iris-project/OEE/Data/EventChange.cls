Include DEMOMACROS

Class OEE.Data.EventChange Extends %Persistent
{

	/// documentation
	Property EquipmentId As %String [ Required ];
	/// documentation
	Property StartTime As %TimeStamp [ Required];
	Property EndTime As %TimeStamp;
	/// documentation
	Property NewStatusCode As %String [Required]; /// We can map this to ISO Status Codes, but need to enable a lookup table to match custom codes with ISO codes
	
	Index EquipmentIdIndex On EquipmentId;
	
	ClassMethod GetLastEventChangeForEquipment(pEquipmentId As %String) As EventChange
	{
		#Dim rs As %SQL.StatementResult
		Set obj = ""
		
		Set rs = ##class(%SQL.Statement).%ExecDirect(,"select ID from OEE_Data.EventChange where EquipmentId=? order by ID desc", pEquipmentId)
		$$$ThrowSQLExceptionIfResultError(rs, "GetLastEventChangeForEquipmentException")
		
		If rs.%Next()
		{
			Set obj = ..%OpenId(rs.%GetData(1))
			Return obj
		}
		
		Return obj
	}
	
Storage Default
{
<Data name="EventChangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EquipmentId</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>EndTime</Value>
</Value>
<Value name="5">
<Value>NewStatusCode</Value>
</Value>
</Data>
<DataLocation>^OEE.Data.EventChangeD</DataLocation>
<DefaultData>EventChangeDefaultData</DefaultData>
<IdLocation>^OEE.Data.EventChangeD</IdLocation>
<IndexLocation>^OEE.Data.EventChangeI</IndexLocation>
<StreamLocation>^OEE.Data.EventChangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}