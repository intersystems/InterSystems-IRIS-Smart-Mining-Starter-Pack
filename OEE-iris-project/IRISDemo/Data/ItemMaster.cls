Class IRISDemo.Data.ItemMaster Extends %Persistent
{

Property ItemCode As %String [ Required ];

Index ItemCodeIndex On ItemCode [ Unique ];

Property ItemRate As %Integer [ Required ];

Storage Default
{
<Data name="ItemMasterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemRate</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.ItemMasterD</DataLocation>
<DefaultData>ItemMasterDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.ItemMasterD</IdLocation>
<IndexLocation>^IRISDemo.Data.ItemMasterI</IndexLocation>
<StreamLocation>^IRISDemo.Data.ItemMasterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
