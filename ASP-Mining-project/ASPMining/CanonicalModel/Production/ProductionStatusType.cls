/// Standarized Production Status. These status are 100% related to the production cycle and are independant of the Operation Status.
Class ASPMining.CanonicalModel.Production.ProductionStatusType Extends %Persistent
{

	/// Type of the status, e.g: 1,2,3,4, 5,6
	Property Type As %Integer;
	/// Description of the status, e.g: TransitToDumpSite, TransitToLoadSite, Loading, Dumping, WaitingForLoad, WaitingForDump. Very important for Production KPIs
	Property Description As %String;
	
	index TypeIndex on Type [unique ];
	
	ClassMethod CreateTypes(){
		set newType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).%New()
		set newType.Type = 1
		set newType.Description = "TransitToDumpSite"
		Set sc = newType.%Save()
		
		set newType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).%New()
		set newType.Type = 2
		set newType.Description = "WaitingForDump"
		Set sc = newType.%Save()
		
		set newType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).%New()
		set newType.Type = 3
		set newType.Description = "Dumping"
		Set sc = newType.%Save()
		
		set newType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).%New()
		set newType.Type = 4
		set newType.Description = "TransitToLoadSite"
		Set sc = newType.%Save()
		
		set newType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).%New()
		set newType.Type = 5
		set newType.Description = "WaitingForLoad"
		Set sc = newType.%Save()
		
		set newType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).%New()
		set newType.Type = 6
		set newType.Description = "Loading"
		Set sc = newType.%Save()
		
		
		
	}
Storage Default
{
<Data name="ProductionStatusTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^ASPMining4037.ProductionSt4A6D</DataLocation>
<DefaultData>ProductionStatusTypeDefaultData</DefaultData>
<IdLocation>^ASPMining4037.ProductionSt4A6D</IdLocation>
<IndexLocation>^ASPMining4037.ProductionSt4A6I</IndexLocation>
<StreamLocation>^ASPMining4037.ProductionSt4A6S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}