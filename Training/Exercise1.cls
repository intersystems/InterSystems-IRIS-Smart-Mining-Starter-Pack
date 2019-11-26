Class Training.Exercise1 Extends %Persistent
{
	ClassMethod Main(){
		write !, "Name: "
		read name
		if name = "" {
			quit
		}
		read !, "Phone: ", phone
		quit:(phone = "") /// post-conditional 
		read !, "DOB: ", dob
		
		write !, "Name: ", ?20, name
		write !, "Phone: ", ?20, phone
		write !, "Dob: ", ?20, dob
	}
Storage Default
{
<Data name="Exercise1DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Training.Exercise1D</DataLocation>
<DefaultData>Exercise1DefaultData</DefaultData>
<IdLocation>^Training.Exercise1D</IdLocation>
<IndexLocation>^Training.Exercise1I</IndexLocation>
<StreamLocation>^Training.Exercise1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}