Class SampleDispatch.BS.Event.PowerViewService Extends Ens.BusinessService
{
/// We are using this custom adapter that is based on EnsLib.SQL.InboundAdapter to hide some properties we don't
/// want people to change.
Parameter ADAPTER = "SampleDispatch.Adapter.SQL.PeriodicInboundAdapterMC";

Property Adapter As SampleDispatch.Adapter.SQL.PeriodicInboundAdapterMC;

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set sc = $$$OK
	
	#Dim oEvent As SampleDispatch.BO.Event.CompleteEvent
	
	try 
	{		
		//Do ..ProcessEnums()
		Do ..ProcessNewEquipments()
		Do ..ProcessNewShifts()
		Do ..ProcessNewReasons()
		Do ..ProcessNewCompleteEvents()
		////Do ..ProcessCompleteDumps()
		
	}
	Catch(oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}
Method ProcessNewShifts()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastShiftKey")
	$$$TRACE("Next shiftindex "_tLastKey_"...")
	
	/// Gets all the new received events
	Set tQueryStatement="SELECT shiftindex, name, year, month#, month, day, shift, date, start, crew#, crew FROM dbo.hist_exproot WHERE shiftindex>? ORDER BY shiftindex"
						
						
	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("shiftindex")
	
				
		// TODO: MISSING HIST_SHIFT_INDEX. Hardcoded time provided for testing, should consider the initial offset time provided by the shift index table.
		If '##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(tLastKey){	
			$$$TRACE("Processing shiftindex "_tLastKey_"...")
			/// oRS.Get Names must match SQL query var names
			set oEvent = ##class(ASPMining.CanonicalModel.Planning.Shift).%New()
			#Dim oEvent As ASPMining.CanonicalModel.Planning.Shift
			set oEvent.Id = oRS.Get("shiftindex")
			
			// TODO: checkear si len y disptime sirven
			set month=oRS.Get("month#")
			set day=oRS.Get("day")
			set year=oRS.Get("year")
			set daysdiff = ##class(%Library.Integer).Normalize(oRS.Get("date")/86400 + 47450 + 32) //transormacion manual de dias de dias unix->dias horlog
			set ztimestampformat = daysdiff_","_oRS.Get("start")
			set oEvent.DateTime = $ZDateTime(ztimestampformat,3)
			//
			set oEvent.StartDay = daysdiff
			set oEvent.StartSeconds = ##class(%Library.Integer).Normalize(oRS.Get("start"))
			
			// Check ShiftType
			If '##class(ASPMining.CanonicalModel.Planning.ShiftType).ShiftTypeIndexExists(oRS.Get("shift")){
				set oEvent.ShiftType = ##class(ASPMining.CanonicalModel.Planning.ShiftType).%New()
				set oEvent.ShiftType.Type = oRS.Get("shift")
				set oEvent.ShiftType.Other = oRS.Get("holiday") // Just as example
			}else{
				set oEvent.ShiftType = ##class(ASPMining.CanonicalModel.Planning.ShiftType).ShiftTypeIndexOpen(oRS.Get("shift"))
			}
			// Check Crew
			if '##class(ASPMining.CanonicalModel.Personnel.Crew).CrewIndexExists(oRS.Get("crew")){
				set oEvent.Crew = ##class(ASPMining.CanonicalModel.Personnel.Crew).%New()
				set oEvent.Crew.Name = oRS.Get("crew")
			}else{
				set oEvent.Crew = ##class(ASPMining.CanonicalModel.Personnel.Crew).CrewIndexOpen(oRS.Get("crew"))
			}
			
			$$$TRACE("Shiftname processed"_oRS.Get("name")_"...")
			$$$TRACE("Datetime"_oEvent.DateTime)
			
			
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Event Operation", oEvent)
		
		}else{
			$$$TRACE("Shiftindex "_tLastKey_" already exists")
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastShiftKey", tLastKey)
	}
	
	
}
/// Will get data from TABLE: hist_statusevents, convert field names to canonical names and send messages to the right operation to save them properly.
/// Only complete events are parsed (start+endtime)
Method ProcessNewCompleteEvents()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastEventKey")
	$$$TRACE("Next event ddbkey "_tLastKey_"...")
	
	/// Gets all the new received events
	Set tQueryStatement="SELECT ddbkey, shiftindex, eqmt, operid, starttime, endtime, reason, duration, status, reasonlink FROM dbo.hist_statusevents WHERE ddbkey>? AND endtime is not null"
						
						
	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("ddbkey")
		$$$TRACE("Processing event ddbkey "_tLastKey_"...")
		
		/// oRS.Get Names must match SQL query var names
		set oEvent = ##class(SampleDispatch.BO.Event.CompleteEvent).%New()
		#Dim oEvent As SampleDispatch.BO.Event.CompleteEvent
		
		set oEvent.EquipmentId = oRS.Get("eqmt") // TODO: Asegurar que se tiene este id en la table Equipment
		//ASK Amir how to do this. if('##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(oEvent.ShiftId))
		
		// TODO: MISSING HIST_SHIFT_INDEX. Hardcoded time provided for testing, should consider the initial offset time provided by the shift index table.
		set oEvent.ShiftId = oRS.Get("shiftindex")
		set oEvent.Duration = oRS.Get("duration")
		
		if '##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(oEvent.ShiftId){
			set shift = ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexOpen(oEvent.ShiftId)			
			set oEvent.StartTime = $ZDateTime(shift.StartDay_","_(shift.StartSeconds + oRS.Get("starttime")))
			$$$TRACE("EVENT StartTime "_oEvent.StartTime_"...")
	
			set oEvent.StartTime = $ZDateTime(shift.StartDay_","_(shift.StartSeconds + oRS.Get("endtime")))
			$$$TRACE("EVENT EndTime "_oEvent.StartTime_"...")
			
			set oEvent.StatusReasonId = oRS.Get("reason") //TODO: Asegurar que se tiene este id en la tabla StatusReason
			set oEvent.StatusTypeId = oRS.Get("status") //TODO: Asegurar que se tiene este id en la tabla StatusType
			
			$$$TRACE("StatusReasonId "_oEvent.StatusReasonId_"...")
						
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Event Operation", oEvent)
		}else{
			$$$TRACE("Skipping event due to: ShiftIndex "_oEvent.ShiftId_" Does not exists for StatusEventId ddbkey: "_oRS.Get("ddbkey"))
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastEventKey", tLastKey)
	}
	
	
}

Method ProcessNewReasons()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastReasonKey")
	$$$TRACE("Next equipment event ddbkey "_tLastKey_"...")
	
	/// Gets all the new received events where equipment is involved, infer form here which ones are new
	Set tQueryStatement="SELECT ddbkey, name, reason, status FROM dbo.hist_reasontable WHERE ddbkey>? "

	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("ddbkey")
		set reasoncode = ##class(%Library.Integer).Normalize(oRS.Get("reason"))
		$$$TRACE("Processing reason ddbkey "_tLastKey_"...")
		
		If '##class(ASPMining.CanonicalModel.Operation.StatusReason).ReasonIndexExists(reasoncode){
			$$$TRACE("Reason does not exists "_reasoncode_"...")
			set oReason = ##class(ASPMining.CanonicalModel.Operation.StatusReason).%New()
			#Dim oReason As ASPMining.CanonicalModel.Operation.StatusReason
			
			set oReason.Reason = reasoncode
			set oReason.Description = oRS.Get("name")
			
			//se verifica el status type aqui, para que en  caso de no existir se guarde automaticamente con la operation, asi es mas rapido despues cuando se obtienen los events
			set statuscode = ##class(%Library.Integer).Normalize(oRS.Get("status"))
			If '##class(ASPMining.CanonicalModel.Operation.StatusType).TypeIndexExists(statuscode) {
				set oReason.StatusType = ##class(ASPMining.CanonicalModel.Operation.StatusType).%New()
				set oReason.StatusType.Type = statuscode
				
				//TODO: aclarar estos status si realmente corresponden
				If (statuscode=1){
					set oReason.StatusType.Description = "Downtime"
				}
				If (statuscode=2){
					set oReason.StatusType.Description = "Production"
				}
				If (statuscode=3){
					set oReason.StatusType.Description = "Delay"
				}
				If (statuscode=4){
					set oReason.StatusType.Description = "Standby"
				}
				If (statuscode>4){
					set oReason.StatusType.Description = "Otro"
				}
			}else{
				set oReason.StatusType = ##class(ASPMining.CanonicalModel.Operation.StatusType).TypeIndexOpen(statuscode)
			}
			
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Event Operation", oReason)
		}else{
			$$$TRACE("Reason already exists "_oRS.Get("reason")_"...")
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastReasonKey", tLastKey)
	}
	
	
}

Method ProcessNewEquipments()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastEquipmentKey")
	$$$TRACE("Next equipment event ddbkey "_tLastKey_"...")
	
	/// Gets all the new received events where equipment is involved, infer form here which ones are new
	Set tQueryStatement="SELECT MIN(ddbkey) as ddbkey, eqmtid, MAX(size) as size, MAX(eqmttype#) as eqmttype#, MAX(eqmttype) as eqmttype, MAX(unit) as unit FROM dbo.hist_eqmtlist WHERE ddbkey>? GROUP BY eqmtid"
	//SELECT MIN(ddbkey) as ddbkey, eqmtid, MAX(size) as size, MAX(eqmttype#) as eqmttype#, MAX(eqmttype) as eqmttype, MAX(unit) as unit FROM dbo.hist_eqmtlist GROUP BY eqmtid

	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("ddbkey")
		$$$TRACE("Processing equipment ddbkey "_tLastKey_"...")
		
		If '##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexExists(oRS.Get("eqmtid")){
			$$$TRACE("Equipment not exists "_oRS.Get("eqmtid")_"...")
			set oEquipment = ##class(ASPMining.CanonicalModel.Equipment.Equipment).%New()
			#Dim oEquipment As ASPMining.CanonicalModel.Equipment.Equipment
			
			set oEquipment.Id = oRS.Get("eqmtid")
			set oEquipment.Name = oRS.Get("unit")_" "_oEquipment.Id
			set oEquipment.Capacity = oRS.Get("size")
			
			If '##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).EquipmentCategoryIndexExists(oRS.Get("unit")){
				set oEquipment.EquipmentCategory = ##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).%New() //TODO: obtener antes las eqmttype
				set oEquipment.EquipmentCategory.Name = oRS.Get("unit")
			}else{
				set oEquipment.EquipmentCategory = ##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).EquipmentCategoryIndexOpen(oRS.Get("unit"),2)
			}
			
			If '##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).EquipmentModelIndexExists(oRS.Get("eqmttype")){
				set oEquipment.EquipmentModel = ##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).%New() //TODO: obtener antes las eqmttype
				set oEquipment.EquipmentModel.Model = oRS.Get("eqmttype")
			}else{
				set oEquipment.EquipmentModel = ##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).EquipmentModelIndexOpen(oRS.Get("eqmttype"),2)
			}
			
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Event Operation", oEquipment)
		}else{
			$$$TRACE("Equipment already exists "_oRS.Get("eqmtid")_"...")
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastEquipmentKey", tLastKey)
	}
	
	
}

Method OnInit() As %Status
{
   #; initialize persistent last key value
   //Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey",0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastReasonKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEquipmentKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastShiftKey", 0)
   /// lAST eVENT KEY IS A TIMESTAMP KEY
   /// Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey", $ZDateTime("0,0", 3))
   /// Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastCompletedDumpKey",0)
   Quit $$$OK
}

}