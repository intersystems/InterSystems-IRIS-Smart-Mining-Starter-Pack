Include DEMOMACROS

Class IRISDemo.Data.ProductionOrderChange Extends %Persistent
{
	Property ProductionOrder As %String [ Required ];
	
	Property ItemMaster As ItemMaster [ Required ];
	
	ForeignKey ItemMasterFK(ItemMaster) References ItemMaster();
	
	Property StartTime as %TimeStamp [required];
	
	Property EndTime as %TimeStamp [required];
	
	Index StartTimeIDX on StartTime;
	
	Index EndTimeIDX on EndTime;
	
	ClassMethod FindByTimeInterval(pStartTime As %TimeStamp, pEndTime As %TimeStamp) As IRISDemo.Data.ProductionOrderChange
	{
		Set id=""
		
		&SQL(select ID into :id from ProductionOrderChange where :pStartTime>=StartTime and :pEndTime<=EndTime)
		$$$ThrowSQLExceptionIfError("ProductionOrderChangeFindByTimeIntervalException")
		
		Quit ..%OpenId(id)
	}
	
	ClassMethod CreateFake(pStartTime As %TimeStamp, pEndTime As %TimeStamp) As IRISDemo.Data.ProductionOrderChange
	{
		Set obj = ..%New()
		Set obj.StartTime = pStartTime
		Set obj.EndTime = pEndTime
		Set obj.ProductionOrder=-$Increment(^Fake.ProductionOrderChange)
		Set obj.ItemMaster = ##class(IRISDemo.Data.ItemMaster).ItemCodeIndexOpen("-1")
		If obj.ItemMaster=""
		{
			Set obj.ItemMaster = ##class(IRISDemo.Data.ItemMaster).%New()
			Set obj.ItemMaster.ItemCode=-1
			Set obj.ItemMaster.ItemRate=0
		}
		
		Set tSC = obj.%Save(1)
		$$$ThrowStatusExceptionIfError(tSC, "CreateFakeSaveException")
		
		Quit obj
	}
	
Storage Default
{
<Data name="ProductionOrderChangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StartTime</Value>
</Value>
<Value name="3">
<Value>EndTime</Value>
</Value>
<Value name="4">
<Value>ProductionOrder</Value>
</Value>
<Value name="5">
<Value>ItemMaster</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.ProductionOBD74D</DataLocation>
<DefaultData>ProductionOrderChangeDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.ProductionOBD74D</IdLocation>
<IndexLocation>^IRISDemo.Data.ProductionOBD74I</IndexLocation>
<StreamLocation>^IRISDemo.Data.ProductionOBD74S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
