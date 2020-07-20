/// Types of shifts have a basic schedule day/night, and can have some extra information like holyday information
Class ASPMining.CanonicalModel.Planning.ShiftType Extends %Persistent
{
/// Shift Type, commonly day and night, e.g: A,B
Property Type As %String;
/// Any special details about this shift, e.g: holyday
Property Other As %String;

Index ShiftTypeIndex On Type [unique];
Storage Default
{
<Data name="ShiftTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Other</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanoniFD10.ShiftTypeD</DataLocation>
<DefaultData>ShiftTypeDefaultData</DefaultData>
<IdLocation>^ASPMining.CanoniFD10.ShiftTypeD</IdLocation>
<IndexLocation>^ASPMining.CanoniFD10.ShiftTypeI</IndexLocation>
<StreamLocation>^ASPMining.CanoniFD10.ShiftTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}