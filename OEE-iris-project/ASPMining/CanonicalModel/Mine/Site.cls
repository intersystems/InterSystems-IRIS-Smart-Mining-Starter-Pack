Class ASPMining.CanonicalModel.Mine.Site Extends %Persistent
{
/// Display Name of the Site
Property Name As %String;
Storage Default
{
<Data name="SiteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^ASPMining.CanonicalMod2AE.SiteD</DataLocation>
<DefaultData>SiteDefaultData</DefaultData>
<IdLocation>^ASPMining.CanonicalMod2AE.SiteD</IdLocation>
<IndexLocation>^ASPMining.CanonicalMod2AE.SiteI</IndexLocation>
<StreamLocation>^ASPMining.CanonicalMod2AE.SiteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}