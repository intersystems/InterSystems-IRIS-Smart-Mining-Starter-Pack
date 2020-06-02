/// Narrow area inside a Site where events are generated from, e.g: Loading spot inside Site A.
Class ASPMining.CanonicalModel.Mine.Location Extends %Persistent
{
/// Grade of the material in this location
Property Grade As %String;
/// Site to which this Location belongs
Property Name As %String;
/// Site to which this Location belongs
Property Site As Site;

index NameIndex on Name [unique];
index GradeIndex on Grade;

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
<Value name="4">
<Value>Name</Value>
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