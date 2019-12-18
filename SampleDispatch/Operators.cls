Class SampleDispatch.Operators Extends %Persistent
{

		/// documentation
		Property Shift as Shifts;
		/// documentation
		Property OperatorId As %String;
		/// documentation
		Property Eqmt As %Integer;
		
		index OperatorIdIndex on OperatorId [unique];
}