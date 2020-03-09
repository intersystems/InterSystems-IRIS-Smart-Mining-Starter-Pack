Class ASPMining.CanonicalModel.Personnel.Operator Extends %Persistent
{
	/// documentation
	Property OperatorId As %String;
	
	/// documentation
	Property Crew As Crews;
	
	/// documentation
	Property OperatorNamre As %String;
	
	index OperatorIdIndex on OperatorId [unique];
}