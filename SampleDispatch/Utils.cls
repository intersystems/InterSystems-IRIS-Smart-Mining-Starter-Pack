Class SampleDispatch.Utils Extends %Persistent
{
	/// documentation
	ClassMethod LoadEverything() 
	{
		Do ..LoadItemMasterShifts("sample_mining_db_shifts.csv")
		Do ..LoadItemMasterECodes("sample_mining_db_event_codes.csv")
		Do ..LoadItemMasterEvents("sample_mining_db_events.csv")
		Do ..LoadItemMasterOperators("sample_mining_db_operators.csv")
	}

	ClassMethod LoadItemMasterECodes(filename As %String)
	{
			#Dim objRs As %Library.ResultSet
			#Dim objPatient As Patient
			
			set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	
			Set tSC = objRs.Execute("/home/xompass/" _ filename) 
			$$$ThrowStatusExceptionIfError(tSC, "LoadItemMasterFileException")
			
			While objRs.Next() 
			{
				set obj = ##class(SampleDispatch.EventCodes).%New()
			
				Set obj.Code =  objRs.Get("code")
				Set obj.Description =  objRs.Get("description")
				
				Set tSC = obj.%Save()
				$$$ThrowStatusExceptionIfError(tSC, "ItemMasterSaveException")
			}
	}
	ClassMethod LoadItemMasterEvents(filename As %String)
	{
			#Dim objRs As %Library.ResultSet
			#Dim objPatient As Patient
			
			set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	
			Set tSC = objRs.Execute("/home/xompass/" _ filename) 
			$$$ThrowStatusExceptionIfError(tSC, "LoadItemMasterFileException")
			
			While objRs.Next() 
			{
				set obj = ##class(SampleDispatch.Events).%New()
			
				Set obj.Time = ..FixTimeStamp(objRs.Get("time"))
				Set obj.Code =  ##class(SampleDispatch.EventCodes).CodeIndexOpen(objRs.Get("code"))
				Set obj.Eqmt = objRs.Get("eqmt")
				
				Set tSC = obj.%Save()
				$$$ThrowStatusExceptionIfError(tSC, "ItemMasterSaveException")
			}
	}
		ClassMethod LoadItemMasterOperators(filename As %String)
	{
			#Dim objRs As %Library.ResultSet
			#Dim objPatient As Patient
			
			set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	
			Set tSC = objRs.Execute("/home/xompass/" _ filename) 
			$$$ThrowStatusExceptionIfError(tSC, "LoadItemMasterFileException")
			
			While objRs.Next() 
			{				
				set obj = ##class(SampleDispatch.Operators).%New()
			
				Set obj.Shift = ##class(SampleDispatch.Shifts).ShiftIdIndexOpen(objRs.Get("shiftid"))
				Set obj.Operator = objRs.Get("opid")
				Set obj.Eqmt = objRs.Get("eqmt")
				
				Set tSC = obj.%Save()
				$$$ThrowStatusExceptionIfError(tSC, "ItemMasterSaveException")
			}
	}
		ClassMethod LoadItemMasterShifts(filename As %String)
	{
			#Dim objRs As %Library.ResultSet
			#Dim objPatient As Patient
			
			set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")
	
			Set tSC = objRs.Execute("/home/xompass/" _ filename) 
			$$$ThrowStatusExceptionIfError(tSC, "LoadItemMasterFileException")
			
			While objRs.Next() 
			{
				set obj = ##class(SampleDispatch.Shifts).%New()
			
				Set obj.ShiftId = objRs.Get("shiftid")
				Set obj.StarTime = ..FixTimeStamp(objRs.Get("start_time"))
				Set obj.EndTime = ..FixTimeStamp(objRs.Get("end_time"))
				
				Set tSC = obj.%Save()
				$$$ThrowStatusExceptionIfError(tSC, "ItemMasterSaveException")
			}
	}
	
	ClassMethod FixTimeStamp(time As %String) As %TimeStamp
	{
			Quit $ZDateTime($ZDateTimeH(time))
	}
	
}