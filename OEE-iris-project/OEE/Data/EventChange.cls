Include DEMOMACROS

Class OEE.Data.EventChange Extends %Persistent
{

	/// documentation
	Property EquipmentId As %String [ Required ];
	
	/// documentation
	Property StartTime As %TimeStamp [ Required];
	
	Property Duration As %Integer;
	
	Property EndTime As %TimeStamp;
	
	Property SessionIds As %String; 
	
	/// documentation
	Property NewStatusCode As %String [Required]; /// We can map this to ISO Status Codes, but need to enable a lookup table to match custom codes with ISO codes
	
	Index EquipmentIdAndStartTimeIndex On (EquipmentId, StartTime, EndTime);
	
	ClassMethod GetLastEventChangeForEquipment(pEquipmentId As %String, pNewEventTime As %TimeStamp) As EventChange
	{
		#Dim rs As %SQL.StatementResult
		Set obj = ""
		
		// Find the last event for the same equipment, that happend just before (the highest StartTime that 
		// is lower than the new event's StarTime. It also must have the EndTime null
		Set rs = ##class(%SQL.Statement).%ExecDirect(,"select ID from OEE_Data.EventChange where EquipmentId=? and StartTime<? and EndTime is null order by StartTime desc", pEquipmentId, pNewEventTime)
		$$$ThrowSQLExceptionIfResultError(rs, "GetLastEventChangeForEquipmentException")
		
		If rs.%Next()
		{
			Set obj = ..%OpenId(rs.%GetData(1))
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
<Value name="6">
<Value>SessionIds</Value>
</Value>
<Value name="7">
<Value>Duration</Value>
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