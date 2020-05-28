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
		//Do ..ProcessNewCompleteDumps()
		//Do ..ProcessNewCompleteLoads()
		
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
	set maxShift = 35070
	Set tQueryStatement="SELECT CONCAT(shiftindex, ddbkey) AS ddbkey, shiftindex, eqmt, operid, starttime, endtime, reason, duration, status, reasonlink FROM dbo.hist_statusevents WHERE shiftindex < "_maxShift_" AND CONCAT(shiftindex, ddbkey)>? AND endtime is not null ORDER BY shiftindex, eqmt asc"
						
						
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
		
		if ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(oEvent.ShiftId){
			set shift = ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexOpen(oEvent.ShiftId)		
			$$$TRACE("LOG1 StartSeconds "_shift.StartSeconds_",starttime: "_oRS.Get("starttime"))	
			
			//Checking if starttime is within same day or next day, this could happen since shifts belong to more than 1 day
			set startseconds = shift.StartSeconds + oRS.Get("starttime")
			set startday = 0 //used for slicing only
			set newstartseconds = 0 //used for slicing only
			$$$TRACE("startseconds: "_startseconds)
			If (startseconds) >= 86400 { //Note: in powerview never seen an event longer than a shift of 12 hours, but just in case this check was made
				set nextday = shift.StartDay + ##class(%Library.Integer).Normalize(startseconds / 86400) //TODO: CHECK IF EVENT THAT ENDS IN LATER DAY/SHIFT REPEATS OR HAS ONLY 1 EVENT
				set newstartseconds =  startseconds # 86400
				$$$TRACE("newstartseconds "_newstartseconds_" startseconds "_startseconds_ " nextday "_nextday)
				set startday = nextday
				set oEvent.StartDate = $ZDateTime(nextday_","_newstartseconds)
			}else{
				set startday = shift.StartDay
				set newstartseconds = startseconds
				set oEvent.StartDate = $ZDateTime(shift.StartDay_","_startseconds)
			}
			$$$TRACE("EVENT StartTimeDT "_oEvent.StartDate_",StartTime: "_oRS.Get("starttime")_ " Duration: "_oEvent.Duration_" EndTime: "_oRS.Get("endtime"))
			
			
			//Checking if endtime is within same day or next day, just like with start time
			set endseconds = shift.StartSeconds + oRS.Get("starttime") + oEvent.Duration
			set endday = 0 //used for splicing only
			$$$TRACE("endseconds: "_endseconds)
			If (endseconds) >= 86400 {
				set nextday = shift.StartDay + ##class(%Library.Integer).Normalize(endseconds / 86400) //TODO: CHECK IF EVENT THAT ENDS IN END OF SHIFT OR IN MANY DAYS LATER, EASY: CHECK IF ANY DURTION LONGER THAN 86400
				set newendseconds = endseconds # 86400
				$$$TRACE("newendseconds "_newendseconds_" endseconds "_endseconds_ " nextday "_nextday)
				set endday = nextday
				set oEvent.EndDate = $ZDateTime(nextday_","_newendseconds)
			}else{
				set endday = shift.StartDay
				set oEvent.EndDate = $ZDateTime(shift.StartDay_","_endseconds)
			}
			$$$TRACE("EVENT EndTime "_oEvent.EndDate_"...")
			
			set oEvent.StatusReasonId = oRS.Get("reason")
			set oEvent.StatusTypeId = oRS.Get("status")
			
			$$$TRACE("StatusReasonId "_oEvent.StatusReasonId_"...")
						
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Event Operation", oEvent)
			
			// SLICING OF THE EVENT
			// Slice the event into fixed length pieces
			set SliceDuration = 300 //5 minutes slices
			
			set firstSliceSlotOffset = newstartseconds # SliceDuration // ej: if i'm at seconds 1534, returns 34 sobran 60
			set firstSliceSlot = newstartseconds - firstSliceSlotOffset // gets the start of the slice slot, e.g: 1500
			set lastSliceSlotOffset = (newstartseconds + oRS.Get("duration") ) # SliceDuration // sobran 154
			set lastSliceSlot = (newstartseconds + oRS.Get("duration") ) - lastSliceSlotOffset
			
			set firstSliceRemainingTime = SliceDuration - firstSliceSlotOffset
			set lastSliceRemainingTime = SliceDuration - lastSliceSlotOffset
			
			// Checks if this events ends in the next window or it ends in the same time window
			set extraSliceCount = ##class(%Library.Integer).Normalize((lastSliceSlot - firstSliceSlot)/SliceDuration)
			
			If ((lastSliceSlot - firstSliceSlot) >= 300){ //only checks if the duration of the event is 1 or more slot spans
				// slice in pieces
				$$$TRACE("EXTRA SLICES on event with ddbkey "_oRS.Get("ddbkey")_" sliceCount: "_extraSliceCount_" firstsliceseconds: "_firstSliceSlot_" startday: "_startday)

				//send fraction of first slot
				set oSliceEvent = ##class(SampleDispatch.BO.Event.SlicedEvent).%New()
				set oSliceEvent.ddbkey = oRS.Get("ddbkey")
				set oSliceEvent.EquipmentId = oRS.Get("eqmt")
				set oSliceEvent.ShiftId = oRS.Get("shiftindex")
				set oSliceEvent.StatusReasonId = oRS.Get("reason")
				set oSliceEvent.StatusTypeId = oRS.Get("status")
				set oSliceEvent.SliceStartDate = $ZDateTime(startday_","_firstSliceSlot)
				set oSliceEvent.PartialDuration = firstSliceRemainingTime / SliceDuration //this event is longer than a single slot so is has the whole remaining time of the first slot

				$$$TRACE("MULTI SLICE first PartialDuration: "_oSliceEvent.PartialDuration) //
				set sc = ..SendRequestAsync("PowerView Event Operation", oSliceEvent) // maybe new operation?
				
				For i=1:1:extraSliceCount {
					//$$$TRACE("EXTRA SLICE i: "_i) //
					set oSliceEvent = ##class(SampleDispatch.BO.Event.SlicedEvent).%New()
					set oSliceEvent.ddbkey = oRS.Get("ddbkey")
					set oSliceEvent.EquipmentId = oRS.Get("eqmt")
					set oSliceEvent.ShiftId = oRS.Get("shiftindex")
					set oSliceEvent.StatusReasonId = oRS.Get("reason")
					set oSliceEvent.StatusTypeId = oRS.Get("status")
					// validate the day we are before anything
					set thisSlotSeconds = firstSliceSlot + (i * SliceDuration)
					If (thisSlotSeconds >= 84600){
						// Will always be only 1 more day if the shifts are 12h or less (considering timezone diff
						set nextday = startday + ##class(%Library.Integer).Normalize(thisSlotSeconds / 86400)
						set oSliceEvent.SliceStartDate = $ZDateTime(nextday_","_(thisSlotSeconds # 86400))
						$$$TRACE("NEXT SLOT StartTime: "_(thisSlotSeconds # 86400))
					}else{
						set oSliceEvent.SliceStartDate = $ZDateTime(startday_","_thisSlotSeconds)
					}
					
					//check if last slot
					If (i = extraSliceCount){
						set oSliceEvent.PartialDuration = lastSliceSlotOffset / SliceDuration
					}else{ //is middle slot
						set oSliceEvent.PartialDuration = 1.0
					}
					$$$TRACE("EXTRA SLICE i: "_i_" PartialDuration: "_oSliceEvent.PartialDuration) //
					set sc = ..SendRequestAsync("PowerView Event Operation", oSliceEvent) // maybe new operation?
				}
				
			}else{
				set oSliceEvent = ##class(SampleDispatch.BO.Event.SlicedEvent).%New()
				set oSliceEvent.ddbkey = oRS.Get("ddbkey")
				set oSliceEvent.EquipmentId = oRS.Get("eqmt")
				set oSliceEvent.ShiftId = oRS.Get("shiftindex")
				set oSliceEvent.StatusReasonId = oRS.Get("reason")
				set oSliceEvent.StatusTypeId = oRS.Get("status")
				set oSliceEvent.SliceStartDate = $ZDateTime(startday_","_firstSliceSlot)
				set oSliceEvent.PartialDuration = (firstSliceRemainingTime - lastSliceRemainingTime) / SliceDuration
				$$$TRACE("SINGLE SLICE ddbkey: "_oSliceEvent.ddbkey_" PartialDuration: "_oSliceEvent.PartialDuration) //
				set sc = ..SendRequestAsync("PowerView Event Operation", oSliceEvent) // maybe new operation?
			}
			
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
	Set tQueryStatement="SELECT MAX(ddbkey) as ddbkey, MAX(name) as name, reason , MAX(status) as status FROM dbo.hist_reasontable WHERE ddbkey>? GROUP BY reason"

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
					set oReason.StatusType.Description = "Delay"
				}
				If (statuscode=3){
					set oReason.StatusType.Description = "Standby"
				}
				If (statuscode=4){
					set oReason.StatusType.Description = "Operative"
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
			set oEquipment.Name = oRS.Get("unit")_" - "_oEquipment.Id
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

/*Method ProcessNewCompleteLoads(){
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastLoadKey")
	$$$TRACE("Next load event key "_tLastKey_"...")
	
	/// Gets all the new received events where equipment is involved, infer form here which ones are new
	Set tQueryStatement="SELECT CONCAT(shiftindex, ddbkey) AS index2, ddbkey, shiftindex, truck, excav, loc, grade, dumpasn, dumprec, measureton, dumptons, timearrive, timedump, timefull, calctravti, loadtons  FROM dbo.hist_loads WHERE CONCAT(shiftindex, ddbkey)>? ORDER BY shiftindex, ddbkey ASC"
	
}*/


Method ProcessNewCompleteDumps()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastDumpKey")
	$$$TRACE("Next dump event key "_tLastKey_"...")
	
	set maxShift = 35070
	/// Gets all the new received events where equipment is involved, infer form here which ones are new
	Set tQueryStatement="SELECT CONCAT(shiftindex, ddbkey) AS index2, ddbkey, shiftindex, truck, excav, loc, grade, bay, loadrec, measureton, dumptons, timearrive, timedump, timeempty, calctravti, dumptons  FROM dbo.hist_dumps WHERE shiftindex < "_maxShift_" AND CONCAT(shiftindex, ddbkey)>? ORDER BY shiftindex, ddbkey ASC"
	//SELECT MIN(ddbkey) as ddbkey, eqmtid, MAX(size) as size, MAX(eqmttype#) as eqmttype#, MAX(eqmttype) as eqmttype, MAX(unit) as unit FROM dbo.hist_eqmtlist GROUP BY eqmtid

	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("index2")
		$$$TRACE("Processing Dump ddbkey "_tLastKey)
		
		If '##class(ASPMining.CanonicalModel.Production.DumpEvent).DumpIndexExists(oRS.Get("index2")){
			$$$TRACE("Dump event does not exists "_oRS.Get("index2")_"...")
			set oDump = ##class(ASPMining.CanonicalModel.Production.DumpEvent).%New()
			#Dim oDump As ASPMining.CanonicalModel.Production.DumpEvent
			
			set shiftindex = oRS.Get("shiftindex")
			set truck = oRS.Get("truck")
			set excav = oRS.Get("excav")
			set loadindex = oRS.Get("loadrec")
											
			set oDump.DumpId = oRS.Get("index2")
			set oDump.MeasuredTons = oRS.Get("dumptons")
			set oDump.TravelTime = oRS.Get("calctravti")
			// check shift
			if '##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(shiftindex){
				$$$TRACE("ERROR IN DUMP: SHIFT DOES NOT EXISTS: "_shiftindex)
			}else{
				set shift = ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexOpen(shiftindex)	
				set oDump.Shift = shift	
				$$$TRACE("Dump Shift StartSeconds "_shift.StartSeconds)
				$$$TRACE("Dump TimeArrive "_oRS.Get("timearrive"))	
				$$$TRACE("Dump TimeDump "_oRS.Get("timedump"))	
				$$$TRACE("Dump TimeEmpty "_oRS.Get("timeempty"))	
				
				set oDump.TimeArrive = ..ShiftOffsetToDateTime(oRS.Get("timearrive"), shiftindex)
				set oDump.TimeDump = ..ShiftOffsetToDateTime(oRS.Get("timedump"), shiftindex)
				set oDump.TimeEmpty = ..ShiftOffsetToDateTime(oRS.Get("timeempty"), shiftindex)
				$$$TRACE("DUMP TimeArrive: "_oDump.TimeDump)
			}
			
			// check truck
			if '##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexExists(truck){
				$$$TRACE("ERROR IN DUMP: TRUCK DOES NOT EXISTS: "_truck)
			}else{
				set oDump.EquipmentTruck = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(truck)
			}
			// check excav
			if '##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexExists(excav){
				$$$TRACE("ERROR IN DUMP: EXCAV DOES NOT EXISTS: "_excav)
			}else{
				set oDump.EquipmentExcav = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(excav)
			}
			
			//check load
			//if '##class(ASPMining.CanonicalModel.Production.LoadEvent).LoadIndexExists()
			
			
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Event Operation", oDump)
		}else{
			$$$TRACE("Dump event already exists "_oRS.Get("index2")_"...")
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastDumpKey", tLastKey)
	}
	
	
}

Method ShiftOffsetToDateTime(offset as %Integer, shiftindex as %Integer){
	if '##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(shiftindex){
		$$$TRACE("SHIFT DOES NOT EXISTS: "_shiftindex)
		Return $ZDateTime("0,0")
	}else{
		set shift = ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexOpen(shiftindex)		
		
		//Checking if starttime is within same day or next day, this could happen since shifts belong to more than 1 day
		set startseconds = shift.StartSeconds + offset
		//$$$TRACE("startseconds: "_startseconds)
		// Check if time in 
		If (startseconds) >= 86400 {
			set nextday = shift.StartDay + ##class(%Library.Integer).Normalize(startseconds / 86400) //TODO: CHECK IF EVENT THAT ENDS IN LATER DAY/SHIFT REPEATS OR HAS ONLY 1 EVENT
			set newstartseconds =  startseconds # 86400
			$$$TRACE("newstartseconds "_newstartseconds_" startseconds "_startseconds_ " nextday "_nextday)
			Return $ZDateTime(nextday_","_newstartseconds)
		}else{
			$$$TRACE("startseconds "_startseconds)
			Return $ZDateTime(shift.StartDay_","_startseconds)
		}
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
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastDumpShiftKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastDumpKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastLoadShiftKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastLoadKey", 0)
   /// lAST eVENT KEY IS A TIMESTAMP KEY
   /// Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey", $ZDateTime("0,0", 3))
   /// Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastCompletedDumpKey",0)
   Quit $$$OK
}


}