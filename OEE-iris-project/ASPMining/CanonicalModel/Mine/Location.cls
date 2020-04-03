/// Narrow area inside a Site where events are generated from, e.g: Loading spot inside Site A.
Class ASPMining.CanonicalModel.Mine.Location Extends %Persistent
{
/// documentation
Property Grade As %Float;
/// documentation
Property Site As Site;
Storage Default
{
<Data name="LocationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Grade</Value>
</Value>
<Value name="3">
<Value>Site</Value>
</Value>
</Data>
<DataLocation>^ASPMining.Canonica2AE.LocationD</DataLocation>
<DefaultData>LocationDefaultData</DefaultData>
<IdLocation>^ASPMining.Canonica2AE.LocationD</IdLocation>
<IndexLocation>^ASPMining.Canonica2AE.LocationI</IndexLocation>
<StreamLocation>^ASPMining.Canonica2AE.LocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}