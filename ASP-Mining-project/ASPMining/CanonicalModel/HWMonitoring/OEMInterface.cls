Class ASPMining.CanonicalModel.HWMonitoring.OEMInterface Extends %Persistent
{
/// Display Name of the OEM Interface
Property Name As %String;
/// Brand of the Interface (optional)
Property Brand As %String;

Index NameIndex On Name [type = bitmap];
Index BrandIndex On Brand [type = bitmap];
Storage Default
{
<Data name="OEMInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Brand</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanE4E6.OEMInterfaceD</DataLocation>
<DefaultData>OEMInterfaceDefaultData</DefaultData>
<IdLocation>^ASPMining.CanE4E6.OEMInterfaceD</IdLocation>
<IndexLocation>^ASPMining.CanE4E6.OEMInterfaceI</IndexLocation>
<StreamLocation>^ASPMining.CanE4E6.OEMInterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}