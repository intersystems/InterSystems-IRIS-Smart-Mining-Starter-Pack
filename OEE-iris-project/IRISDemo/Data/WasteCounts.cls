Class IRISDemo.Data.WasteCounts Extends %Persistent
{

Property ProductionOrder As ProductionOrderChange [ Required ];

ForeignKey ProductionOrderFK(ProductionOrder) References ProductionOrderChange();

Property WasteCount As %Integer [ Required ];

Property StartTime As %TimeStamp [ Required ];

Property EndTime As %TimeStamp [ Required ];

Index StartTimeIDX On StartTime;

Index EndTimeIDX On EndTime;

Storage Default
{
<Data name="WasteCountsDefaultData">
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
<Value>WasteCount</Value>
</Value>
<Value name="5">
<Value>ProductionOrder</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.WasteCountsD</DataLocation>
<DefaultData>WasteCountsDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.WasteCountsD</IdLocation>
<IndexLocation>^IRISDemo.Data.WasteCountsI</IndexLocation>
<StreamLocation>^IRISDemo.Data.WasteCountsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
