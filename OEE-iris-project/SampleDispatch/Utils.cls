Include DEMOMACROS

Class SampleDispatch.Utils
{
	/// documentation
	ClassMethod LoadEverything() 
	{
		Do ..LoadEqmt("/tmp/sample_mining_db_eqmt.csv")
		Do ..LoadShifts("/tmp/sample_mining_db_shifts.csv")
		Do ..LoadEventCodes("/tmp/sample_mining_db_event_codes.csv")
		Do ..LoadEvents("/tmp/sample_mining_db_events.csv")
		Do ..LoadOperators("/tmp/sample_mining_db_operators.csv")
		Do ..LoadLoads("/tmp/sample_mining_db_loads.csv")
		Do ..LoadDumps("/tmp/sample_mining_db_dumps.csv")
	}
	ClassMethod LoadEqmt(filename As %String)
	{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute( filename) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadItemMasterFileException")
		
		While objRs.Next() 
		{
			set obj = ##class(SampleDispatch.Eqmt).%New()
		
			Set obj.EqmtCode =  objRs.Get("eqmt")
			if (obj.EqmtCode = "")
			{
				Quit
			}
			Set obj.Name =  objRs.Get("Name")
			
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "LoadEqmtSaveException")
		}
	}
	
	ClassMethod LoadEventCodes(filename As %String)
	{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute( filename) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadFileException")
		
		While objRs.Next() 
		{
			set obj = ##class(SampleDispatch.EventCodes).%New()
		
			Set obj.Code =  objRs.Get("code")
			Set obj.Description =  objRs.Get("description")
			
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "LoadEventCodesSaveException")
		}
	}
	
	ClassMethod LoadEvents(filename As %String)
	{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute( filename) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadFileException")
		
		While objRs.Next() 
		{
			set obj = ##class(SampleDispatch.Events).%New()
		
			Set obj.EventTime = ..FixTimeStamp(objRs.Get("time"))
			Set obj.Code =  ##class(SampleDispatch.EventCodes).CodeIndexOpen(objRs.Get("code"))
			Set obj.Eqmt = ##class(SampleDispatch.Eqmt).EqmtIndexOpen(objRs.Get("eqmt"))
			
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "LoadEventsSaveException")
		}
	}
	
	ClassMethod LoadOperators(filename As %String)
	{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute( filename) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadFileException")
		
		While objRs.Next() 
		{				
			set obj = ##class(SampleDispatch.Operators).%New()
		
			Set obj.Shift = ##class(SampleDispatch.Shifts).ShiftIdIndexOpen(objRs.Get("shiftid"))
			Set obj.OperatorId = objRs.Get("opid")
			Set obj.Eqmt = ##class(SampleDispatch.Eqmt).EqmtIndexOpen(objRs.Get("eqmt"))
			
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "LoadOperatorsSaveException")
		}
	}
	
	ClassMethod LoadShifts(filename As %String)
	{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute( filename) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadFileException")
		
		While objRs.Next() 
		{
			set obj = ##class(SampleDispatch.Shifts).%New()
		
			Set obj.ShiftId = objRs.Get("shiftid")
			Set obj.StartTime = ..FixTimeStamp(objRs.Get("start_time"))
			Set obj.EndTime = ..FixTimeStamp(objRs.Get("end_time"))
			
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "LoadShiftsSaveException")
		}
	}
	
	ClassMethod LoadLoads(filename As %String)
	{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute( filename) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadItemMasterFileException")
		
		While objRs.Next() 
		{		
			set obj = ##class(SampleDispatch.Loads).%New()
			Set obj.Eqmt =  ##class(SampleDispatch.Eqmt).EqmtIndexOpen(objRs.Get("eqmt"))
			Set obj.Time =  ..FixTimeStamp(objRs.Get("time"))
			Set obj.Tons =  objRs.Get("tons")
			
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "LoadLoadsSaveException")
		}
	}
	
	ClassMethod LoadDumps(filename As %String)
	{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute( filename) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadItemMasterFileException")
		
		While objRs.Next() 
		{
			set obj = ##class(SampleDispatch.Dumps).%New()
			Set obj.Eqmt =  ##class(SampleDispatch.Eqmt).EqmtIndexOpen(objRs.Get("eqmt"))
			Set obj.Time =  ..FixTimeStamp(objRs.Get("time"))
			Set obj.EndTime =  ..FixTimeStamp(objRs.Get("end_time"))
			Set obj.Tons =  objRs.Get("tons")
			
			
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "LoadDumpsSaveException")
		}
	}
	
	ClassMethod FixTimeStamp(time As %String) As %TimeStamp
	{
		Quit $ZDateTime($ZDateTimeH(time,,,,6),3)
	}

}