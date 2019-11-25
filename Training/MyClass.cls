/// Basics tutorial guide
Class Training.MyClass Extends %Persistent
{
	ClassMethod Multiplicar(arg1 As %Integer, arg2 As %Double){
	    /// Everything here can be directly typed in Terminal
	    /// This function can be called from Terminal as: 
	    /** iris terminal IRIS
	    set $namespace = "DEV-MINING"
	    ##class(Training.MyClass).Multiplicar(1,2)
	    **/
	    
		write "Resultado ",!,"multiplicacion: ",?49, arg1*arg2
		write !, "Agregar prametro: "
		read x
		write "Resultado nueva multiplicacion: ",?49, arg1*arg2*x
		write !, "Resultado 5 elevado a 2 ", 5 ** 2
		write !, "Modulo 5%2 = ", 5 # 2
		/// NOTA: Siempre usar parentesis en las operaciones, ya que no tiene precedencia https://cedocs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=TCOS_Precedence
		//Ingresar dob (date of birth) como mm/ss/yyyy
		read !, "DOB: ", dob   set days = $h - $zdateh(dob), today = $zdate(+$h)
		write !, "On ", today, ", you are ", days, " days old."
		///write ///argumentless write displays all variables
		///kill ///kill deletes all variables in memory
		
		//Operadores logicos https://cedocs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=TCOS_Logical
		if (arg1 = 1 && arg2 = 2){
			write !, "arg1=1 and arg2=2!!"
		}elseif (arg1 = 0 || arg2 = 0){
			write !, "arg1 or arg2 is 0"
		}else{
		    write !, "arg1 and arg2 were random"
		}
		
		return arg1 * arg2
	}
	
	/// Tipos de errores
Storage Default
{
<Data name="MyClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Training.MyClassD</DataLocation>
<DefaultData>MyClassDefaultData</DefaultData>
<Description>
<![CDATA[Tipos de errores]]></Description>
<IdLocation>^Training.MyClassD</IdLocation>
<IndexLocation>^Training.MyClassI</IndexLocation>
<StreamLocation>^Training.MyClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}