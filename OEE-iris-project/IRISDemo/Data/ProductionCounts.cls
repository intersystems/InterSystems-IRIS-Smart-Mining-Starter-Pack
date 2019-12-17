Class IRISDemo.Data.ProductionCounts Extends %Persistent
{

Property ProductionOrder As ProductionOrderChange [ Required ];

ForeignKey ProductionOrderFK(ProductionOrder) References ProductionOrderChange();

Property ProductionCount As %Integer [ Required ];

Property StartTime As %TimeStamp [ Required ];

Property EndTime As %TimeStamp [ Required ];

Index StartTimeIDX On StartTime;

Index EndTimeIDX On EndTime;

Storage Default
{
<Data name="ProductionCountsDefaultData">
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
<Value>ProductionCount</Value>
</Value>
<Value name="5">
<Value>ProductionOrder</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.ProductionCA81DD</DataLocation>
<DefaultData>ProductionCountsDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.ProductionCA81DD</IdLocation>
<IndexLocation>^IRISDemo.Data.ProductionCA81DI</IndexLocation>
<StreamLocation>^IRISDemo.Data.ProductionCA81DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
