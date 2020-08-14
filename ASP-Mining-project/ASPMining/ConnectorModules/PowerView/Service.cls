Class ASPMining.ConnectorModules.PowerView.Service Extends Ens.BusinessService
{

/// We are using this custom adapter that is based on EnsLib.SQL.InboundAdapter to hide some properties we don't
/// want people to change.
Parameter ADAPTER = "ASPMining.ConnectorModules.Adapter.SQL.PeriodicInboundAdapter";

Property Adapter As ASPMining.ConnectorModules.Adapter.SQL.PeriodicInboundAdapter;

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	Set sc = $$$OK
	
	#Dim oEvent As ASPMining.ConnectorModules.BO.CompleteEvent
	
	try 
	{		
		//Do ..ProcessEnums()
		Do ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).CreateTypes()
		Do ..ProcessNewEquipments()
		Do ..ProcessNewShifts()
		Do ..ProcessNewReasons()
		//Do ..ProcessNewCompleteEvents(35066) //this is still here because sliced are still generated here
		Do ..ProcessAllEvents(36000)
		//Do ..ProcessDumpAndLoadEvents(35066) //need to remove the splicing on this
		
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
			set daysdiff = ##class(%Library.Integer).Normalize(oRS.Get("date")/86400 + 47085 + 32) //transormacion manual de dias de dias unix->dias horlog TOD: restar 365
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
			
			set sc = ..SendRequestAsync("PowerView Operation", oEvent)
		
		}else{
			$$$TRACE("Shiftindex "_tLastKey_" already exists")
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastShiftKey", tLastKey)
	}
}

/// Will get data from TABLE: hist_statusevents, convert field names to canonical names and send messages to the right operation to save them properly.
/// Only complete events are parsed (start+endtime)
Method ProcessNewCompleteEvents(shiftToQuery As %Integer)
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastEventKey")
	$$$TRACE("Next event ddbkey "_tLastKey_"...")
	
	/// Gets all the new received events
	set maxShiftToQuery = shiftToQuery
	Set tQueryStatement="SELECT CONCAT(shiftindex, ddbkey) AS ddbkey, shiftindex, eqmt, operid, starttime, endtime, reason, duration, status, reasonlink "_
	" FROM dbo.hist_statusevents WHERE shiftindex <= '"_maxShiftToQuery_"' "_
	" AND CONCAT(shiftindex, ddbkey)>? AND endtime is not null "_
	" ORDER BY shiftindex, eqmt asc"
						
						
	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("ddbkey")
		$$$TRACE("Processing event ddbkey "_tLastKey_"...")
		
		/// oRS.Get Names must match SQL query var names
		set oEvent = ##class(ASPMining.ConnectorModules.BO.CompleteEvent).%New()
		#Dim oEvent As ASPMining.ConnectorModules.BO.CompleteEvent
		
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
			$$$TRACE("EVENT StartTimeDT "_oEvent.StartDate_",StartTime: "_oRS.Get("starttime")_ " Duration: "_oEvent.Duration)
			
			
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
									
			set sc = ..SendRequestAsync("PowerView Operation", oEvent)
			
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
				set oSliceEvent = ##class(ASPMining.ConnectorModules.BO.SlicedEvent).%New()
				set oSliceEvent.ddbkey = oRS.Get("ddbkey")
				set oSliceEvent.EquipmentId = oRS.Get("eqmt")
				set oSliceEvent.ShiftId = oRS.Get("shiftindex")
				set oSliceEvent.StatusReasonId = oRS.Get("reason")
				set oSliceEvent.StatusTypeId = oRS.Get("status")
				set oSliceEvent.SliceStartDate = $ZDateTime(startday_","_firstSliceSlot)
				set oSliceEvent.PartialDuration = firstSliceRemainingTime / SliceDuration //this event is longer than a single slot so is has the whole remaining time of the first slot

				$$$TRACE("MULTI SLICE first PartialDuration: "_oSliceEvent.PartialDuration) //
				set sc = ..SendRequestAsync("PowerView Operation", oSliceEvent) // maybe new operation?
				
				For i=1:1:extraSliceCount {
					//$$$TRACE("EXTRA SLICE i: "_i) //
					set oSliceEvent = ##class(ASPMining.ConnectorModules.BO.SlicedEvent).%New()
					set oSliceEvent.ddbkey = oRS.Get("ddbkey")
					set oSliceEvent.EquipmentId = oRS.Get("eqmt")
					set oSliceEvent.ShiftId = oRS.Get("shiftindex")
					set oSliceEvent.StatusReasonId = oRS.Get("status")_ "-" _oRS.Get("reason")
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
					set sc = ..SendRequestAsync("PowerView Operation", oSliceEvent) // maybe new operation?
				}
				
			}else{
				set oSliceEvent = ##class(ASPMining.ConnectorModules.BO.SlicedEvent).%New()
				set oSliceEvent.ddbkey = oRS.Get("ddbkey")
				set oSliceEvent.EquipmentId = oRS.Get("eqmt")
				set oSliceEvent.ShiftId = oRS.Get("shiftindex")
				set oSliceEvent.StatusReasonId = oRS.Get("status")_ "-" _oRS.Get("reason")
				set oSliceEvent.StatusTypeId = oRS.Get("status")
				set oSliceEvent.SliceStartDate = $ZDateTime(startday_","_firstSliceSlot)
				set oSliceEvent.PartialDuration = (firstSliceRemainingTime - lastSliceRemainingTime) / SliceDuration
				$$$TRACE("SINGLE SLICE ddbkey: "_oSliceEvent.ddbkey_" PartialDuration: "_oSliceEvent.PartialDuration) //
				set sc = ..SendRequestAsync("PowerView Operation", oSliceEvent) // maybe new operation?
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
	
	//Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastReasonKey")
	//$$$TRACE("Next reason ddbkey "_tLastKey_"...")
	
	/// Gets all the new received events where equipment is involved, infer form here which ones are new
	Set tQueryStatement="SELECT DISTINCT name, status, reason FROM dbo.hist_reasontable WHERE reason <> '' ORDER BY name"

	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement)
	
	While oRS.Next()
	{
		//Set tLastKey = oRS.Get("ddbkey")
		set statuscode = ##class(%Library.Integer).Normalize(oRS.Get("status"))
		set reasoncode = ##class(%Library.Integer).Normalize(oRS.Get("reason"))
		//$$$TRACE("Processing reason ddbkey "_tLastKey_"...")
		set reasonId = statuscode_ "-" _reasoncode
		If '##class(ASPMining.CanonicalModel.Operation.StatusReason).IdIndexExists(reasonId){
			$$$TRACE("Reason does not exists "_reasoncode_"...")
			set oReason = ##class(ASPMining.CanonicalModel.Operation.StatusReason).%New()
			#Dim oReason As ASPMining.CanonicalModel.Operation.StatusReason
			
			set oReason.Id = reasonId
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
					set oReason.StatusType.Description = "Operative"
				}
				If (statuscode=3){
					set oReason.StatusType.Description = "Standby"
				}
				If (statuscode=4){
					set oReason.StatusType.Description = "Delay"
				}
				If (statuscode>4){
					set oReason.StatusType.Description = "Otro"
				}
			}else{
				set oReason.StatusType = ##class(ASPMining.CanonicalModel.Operation.StatusType).TypeIndexOpen(statuscode)
			}
			
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Operation", oReason)
		}else{
			$$$TRACE("Reason already exists "_oRS.Get("reason")_"...")
		}
		
		//Do ..Adapter.SetPersistentValue(..%ConfigName, "LastReasonKey", tLastKey)
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
			//set oEquipment.LastUnifiedEvent = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).%New()
			
			If '##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).EquipmentCategoryIndexExists(oRS.Get("unit")){
				set oEquipment.EquipmentCategory = ##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).%New() //TODO: obtener antes las eqmttype
				set oEquipment.EquipmentCategory.Name = oRS.Get("unit")
				set oEquipment.EquipmentCategory.Description = oRS.Get("unit")
			}else{
				set oEquipment.EquipmentCategory = ##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).EquipmentCategoryIndexOpen(oRS.Get("unit"),2)
			}
			
			If '##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).EquipmentModelIndexExists(oRS.Get("eqmttype")){
				set oEquipment.EquipmentModel = ##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).%New() //TODO: obtener antes las eqmttype
				set oEquipment.EquipmentModel.Model = oRS.Get("eqmttype")
				set oEquipment.EquipmentModel.Description = oRS.Get("eqmttype")
			}else{
				set oEquipment.EquipmentModel = ##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).EquipmentModelIndexOpen(oRS.Get("eqmttype"),2)
			}
			
			
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Operation", oEquipment)
		}else{
			$$$TRACE("Equipment already exists "_oRS.Get("eqmtid")_"...")
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastEquipmentKey", tLastKey)
	}
}

Method ProcessAllEvents(shiftToQuery As %Integer)
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tDumpLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "UnifiedLastDumpKey")
	Set tLoadLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "UnifiedLastLoadKey")
	Set tStatusLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "UnifiedLastStatusKey")
	$$$TRACE("Next load/dump event key "_tLoadLastKey_"..."_tDumpLastKey)
	set maxShiftIndex = shiftToQuery 
	
	// Selecting TOP 50K rows for each column, better perfomance will be obtained if precessing shift by shift->this could be implemented in the top loop, or keeping track of that varaible in the adapter
	Set tQueryStatement="SELECT * FROM ("_
		"SELECT TOP 50000 cast(shiftindex as int) as shiftindex, (cast(shiftindex as bigint)*1000000 + timearrive*10) AS index2, ddbkey, cast(timearrive as int) as timearrive, timedump, null as timeload,(cast(timeempty as int) - timearrive) as delta, timeempty, null as timefull, dumptons, null as loadtons"_
		" , truck, excav, loc, grade, bay, measureton, extraload, null as eqmt, null as status, null as reason, null as operid "_ //common columns
		" FROM [hist_dumps] "_
		" WHERE shiftindex <= " _maxShiftIndex_ " AND extraload = '0' AND (cast(shiftindex as bigint)*1000000 + timearrive*10) > ? "_
		" ORDER BY shiftindex ASC, timearrive ASC  "_
	") AS A1 "_    //from here we need: shiftindex, index2, ddbkey?, timearrive, timedump, timefull, delta, dumptons, truck, excav, loc, grade, bay?, measureton, extraload
    " UNION "_
    " SELECT * FROM ("_
		"SELECT TOP 50000 cast(shiftindex as int) as shiftindex, (cast(shiftindex as bigint)*1000000 + timearrive*10) AS index2, ddbkey, cast(timearrive as int) as timearrive, null as timedump, timeload,(cast(timefull as int) - timearrive) as delta, null as timeempty, timefull, null as dumptons, loadtons"_
		" , truck, excav, loc, grade, null as bay, measureton, extraload, null as eqmt, null as status, null as reason, null as operid "_ //common columns
    	"FROM [hist_loads] "_
    	"WHERE shiftindex <= " _maxShiftIndex_ " AND extraload = '0'  AND (cast(shiftindex as bigint)*1000000 + timearrive*10) > ? "_
    	"ORDER BY shiftindex ASC, timearrive ASC  "_
    ") AS A2 "_ //from here we need: shiftindex, index2, ddbkey?, timearrive, timeload, timeempty, delta, loadtons, truck, excav, loc, grade, measureton, extraload
    " UNION "_ 
    " SELECT * FROM ( "_
    	"SELECT TOP 50000 cast(shiftindex as int) as shiftindex, (cast(shiftindex as bigint)*1000000 + starttime*10) AS index2, ddbkey, cast(starttime as int) as timearrive, null as timedump, null as timeload, duration as delta, null as timeempty, null as timefull, null as dumptons, null as loadtons "_
    	" , null as truck, null as excav, null as loc, null as grade, null as bay, null as measureton, null as extraload, eqmt, status, reason, operid "_
    	"FROM [hist_statusevents] "_
    	"WHERE ddbkey > 0 and shiftindex <= " _maxShiftIndex_ " AND (cast(shiftindex as bigint)*1000000 + starttime*10) > ? "_
    	" ORDER BY shiftindex ASC, timearrive ASC  "_
	") AS A3 "_ //from here we need: shiftindex, index2, ddbkey to filter, starttime as timearrive, delta?, eqmt, status, reason, operid
    " ORDER BY shiftindex ASC, timearrive, delta ASC " //delta is used to guarantee order when 2 events related to same equipment happen at the same time (one of the events has a duration = 0)

    
	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tDumpLastKey, tLoadLastKey, tStatusLastKey)

	// Revisar fila, ver si el evento nuevo es un dump, load, o status, 
	// Si es load o dump, genera un productionEvent, si es *status lo dejamos pasar hasta q se implemente junto con su slicing. por ahora estaremos haciendo 2 queries a status events
	// Evento nuevo es un nuevo UnifiedEvent
	// Evento nuevo clona los campos del ultimo UnifiedEvent del Equipment excepto lo q sea nuevo
	// Se debe modificar el campo "Duration" del ultimo UnifiedEvent del Equipment y %Save al UnifiedEvent
	// Se actualiza el ultimo UnifiedEvent del Equipment y se le hace %Save al Equipment
	// next
	
	
	While oRS.Next()
	{
		$$$TRACE("Analyzing query: "_oRS.Get("index2"))
		Set ..%SessionId=""
		
		$$$TRACE("timedump:"_oRS.Get("timedump")_" timeload:"_oRS.Get("timeload")_" eqmt:"_oRS.Get("eqmt"))
		
		set uniqueId = oRS.Get("index2")

		If (oRS.Get("timedump") '= ""){
			Set tDumpLastKey = oRS.Get("index2")
			
			$$$TRACE("Processing Dump last key "_oRS.Get("index2"))
			
			If '##class(ASPMining.CanonicalModel.Production.DumpEvent).DumpIndexExists(oRS.Get("index2")){
				$$$TRACE("Dump event does not exists "_oRS.Get("index2")_"...")
				set shiftindex = oRS.Get("shiftindex")
				set truck = oRS.Get("truck")
				set excav = oRS.Get("excav")
				set loadindex = oRS.Get("loadrec")
				set location = oRS.Get("loc")
				
				set timearrive = oRS.Get("timearrive")
				set timedump = oRS.Get("timedump")
				set timeempty = oRS.Get("timeempty")
				set measuretons = oRS.Get("measureton")
				
				set shift = ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexOpen(shiftindex)
				set equipment = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(truck)
				
				set oDump = ##class(ASPMining.CanonicalModel.Production.DumpEvent).%New()
				#Dim oDump As ASPMining.CanonicalModel.Production.DumpEvent
												
				set oDump.DumpId = oRS.Get("index2")
				set oDump.MeasuredTons = oRS.Get("measureton")
				//set oDump.TravelTime = oRS.Get("calctravti")
				
				// check shift
				if '##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(shiftindex){
					$$$TRACE("ERROR IN DUMP: SHIFT DOES NOT EXISTS: "_shiftindex)
				} else {
					set shift = ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexOpen(shiftindex)	
					set oDump.Shift = shift	
					$$$TRACE("Dump Shift StartSeconds "_shift.StartSeconds)
					$$$TRACE("Dump TimeArrive "_timearrive)	
					$$$TRACE("Dump TimeDump "_timedump)	
					$$$TRACE("Dump TimeEmpty "_timeempty)	
					
					set oDump.TimeArrive = ..ShiftOffsetToDateTime(timearrive, shiftindex)
					set oDump.TimeDump = ..ShiftOffsetToDateTime(timedump, shiftindex)
					set oDump.TimeEmpty = ..ShiftOffsetToDateTime(timeempty, shiftindex)
					$$$TRACE("DUMP TimeArrive: "_oDump.TimeArrive)
				}
				
				// check truck
				if '##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexExists(truck){
					$$$TRACE("ERROR IN DUMP: TRUCK DOES NOT EXISTS: "_truck)
				} else {
					set oDump.EquipmentTruck = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(truck)					
				}
				// check excav
				if '##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexExists(excav){
					$$$TRACE("ERROR IN DUMP: EXCAV DOES NOT EXISTS: "_excav)
				} else {
					set oDump.EquipmentExcav = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(excav)
				}
				
				// check locations
				if '##class(ASPMining.CanonicalModel.Mine.Location).NameIndexExists(location){
					$$$TRACE("DUMP: LOC DOES NOT EXISTS: "_location)
					set oDump.Location = ##class(ASPMining.CanonicalModel.Mine.Location).%New()
					set oDump.Location.Name = location
					set oDump.Location.Grade = oRS.Get("grade")
				} else {
					set oDump.Location = ##class(ASPMining.CanonicalModel.Mine.Location).NameIndexOpen(location)
				}
				
				set sc = ..SendRequestAsync("PowerView Operation", oDump)
				
				// Hasta aqui todo tablas estandard
				// ************************
				// Desde Aqui nuevo unified para oee
				
				// Se supone q el truck existe y
				// se obtiene su ultimo lastunified event
				
				// Eventos produccion: 1-> actualizo el evento transit anterior. 2-> genero el evento waiting actual ,3-> genero el evento dumping actual 4-> genero evento transit nuevo (incompleto)
				
				$$$TRACE("DUMP: Generating New Production Events")
				//TODO: add "grade" to location if it doesnt exists
				// debo crear 3  productionevent con tipo transit to dump, waiting to dump, dump con su correspondiente unified event.
				set productionEvent1 = ##class(ASPMining.CanonicalModel.Production.ProductionEvent).%New()
				set productionEvent1.Id = uniqueId
				set productionEvent1.Equipment = equipment
				set productionEvent1.ProductionStatusType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).TypeIndexOpen(2) //waiting to dump
				set productionEvent1.Location = ##class(ASPMining.CanonicalModel.Mine.Location).NameIndexOpen(location)
				set productionEvent1.Shift = shift
				set productionEvent1.StartTime = ..ShiftOffsetToDateTime(timearrive, shiftindex)
				set productionEvent1.MeasuredTons = measuretons
				
				set productionEvent2 = ##class(ASPMining.CanonicalModel.Production.ProductionEvent).%New()
				set productionEvent2.Id = uniqueId+1
				set productionEvent2.Equipment = equipment
				set productionEvent2.ProductionStatusType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).TypeIndexOpen(3) //dumping
				set productionEvent2.Location = ##class(ASPMining.CanonicalModel.Mine.Location).NameIndexOpen(location)
				set productionEvent2.Shift = shift
				set productionEvent2.StartTime = ..ShiftOffsetToDateTime(timedump, shiftindex)
				set productionEvent2.MeasuredTons = measuretons
				//update previous production event
				set productionEvent1.Duration = $System.SQL.DATEDIFF("second", productionEvent1.StartTime , productionEvent2.StartTime)
				
				
				set productionEvent3 = ##class(ASPMining.CanonicalModel.Production.ProductionEvent).%New()
				set productionEvent3.Id = uniqueId+2
				set productionEvent3.Equipment = equipment
				set productionEvent3.ProductionStatusType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).TypeIndexOpen(4) //transit to load
				set productionEvent3.Location = ##class(ASPMining.CanonicalModel.Mine.Location).NameIndexOpen(location)
				set productionEvent3.Shift = shift
				set productionEvent3.StartTime = ..ShiftOffsetToDateTime(timeempty, shiftindex)
				set productionEvent3.MeasuredTons = measuretons
				//update previous production event
				set productionEvent2.Duration = $System.SQL.DATEDIFF("second", productionEvent2.StartTime , productionEvent3.StartTime)
				

				$$$TRACE("DUMP: Generating New Unified Events")
				
				set unifiedEvent1 = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).%New()
				set unifiedEvent1.Id = uniqueId
				set unifiedEvent1.Equipment = equipment
				set unifiedEvent1.Shift = shift
				set unifiedEvent1.ProductionEvent = productionEvent1 
				set unifiedEvent1.EventDateTime = productionEvent1.StartTime 
				set unifiedEvent1.Duration = 0 
				//update previous unifiedEvent event
				
				
				set unifiedEvent2 = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).%New()
				set unifiedEvent2.Id = uniqueId + 1
				set unifiedEvent2.Equipment = equipment
				set unifiedEvent2.Shift = shift
				set unifiedEvent2.ProductionEvent = productionEvent2
				set unifiedEvent2.EventDateTime = productionEvent2.StartTime 
				set unifiedEvent2.Duration = 0 
				//update previous unifiedEvent event
				set unifiedEvent1.Duration = $System.SQL.DATEDIFF("second", unifiedEvent1.EventDateTime, unifiedEvent2.EventDateTime)
				set unifiedEvent1.OperativeDuration = unifiedEvent1.Duration
				
				
				set unifiedEvent3 = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).%New()
				set unifiedEvent3.Id = uniqueId + 2
				set unifiedEvent3.Equipment = equipment
				set unifiedEvent3.Shift = shift
				set unifiedEvent3.ProductionEvent = productionEvent3 
				set unifiedEvent3.EventDateTime = productionEvent3.StartTime 
				set unifiedEvent3.Duration = 0 
				//update previous unifiedEvent event
				set unifiedEvent2.Duration = $System.SQL.DATEDIFF("second", unifiedEvent2.EventDateTime, unifiedEvent3.EventDateTime)
				set unifiedEvent2.OperativeDuration = unifiedEvent2.Duration
				
								
				set lastTrackUEvent = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(truck).LastUnifiedEvent
				If ( lastTrackUEvent '= ""){

					set lastUnifiedEvent = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).IdIndexOpen(lastTrackUEvent.Id)
					
					If (lastUnifiedEvent.ProductionEvent '= ""){
						set lastUnifiedEvent.ProductionEvent.Duration = $System.SQL.DATEDIFF("second", lastUnifiedEvent.ProductionEvent.StartTime , productionEvent1.StartTime)
					}

					set productionEvent1.PreviousLocation = lastUnifiedEvent.ProductionEvent.Location
					set productionEvent2.PreviousLocation = lastUnifiedEvent.ProductionEvent.Location
					set productionEvent3.PreviousLocation = lastUnifiedEvent.ProductionEvent.Location
					
					// Update trip information:
					set tripId = productionEvent1.PreviousLocation.Name_"-"_productionEvent1.Location.Name
					If ('##class(ASPMining.CanonicalModel.Mine.Trip).IdIndexExists(tripId)){
						
						//this is the time between last production event and current production event, so for KPI puropses, the non operative time must be substracted
						set travelTime = productionEvent1.Duration 

						set trip = ##class(ASPMining.CanonicalModel.Mine.Trip).%New()
						#Dim trip as ASPMining.CanonicalModel.Mine.Trip
						set trip.Id = tripId
						set trip.Name = productionEvent1.PreviousLocation.Name_" to "_productionEvent1.Location.Name
						set trip.OriginLocation = productionEvent1.PreviousLocation
						set trip.DestinationLocation = productionEvent1.Location
						set trip.ReferenceTravelTime = travelTime
						set trip.MinTravelTime = travelTime
						set trip.MaxTravelTime = travelTime
						set trip.TravelCount = 1
						set trip.TotalTravelTime = travelTime
						set trip.AvgTravelTime = trip.TotalTravelTime / trip.TravelCount
					} else {
						set travelTime = productionEvent1.Duration 

						set trip = ##class(ASPMining.CanonicalModel.Mine.Trip).IdIndexOpen(tripId)
						#Dim trip as ASPMining.CanonicalModel.Mine.Trip
						If (travelTime < trip.MinTravelTime){
							set trip.MinTravelTime = travelTime
						}
						If (travelTime > trip.MaxTravelTime){
							set trip.MaxTravelTime = travelTime
						}
						set trip.ReferenceTravelTime = (trip.MinTravelTime  + trip.MaxTravelTime) / 2
						set trip.TravelCount = trip.TravelCount + 1
						set trip.TotalTravelTime = trip.TotalTravelTime + travelTime
						set trip.AvgTravelTime = trip.TotalTravelTime / trip.TravelCount
					}
					// save the trip right now to dont wait for the operation
					// add this trip to the unified event
					set sc = trip.%Save()
					set unifiedEvent1.Trip = trip
					set unifiedEvent2.Trip = trip
					set unifiedEvent3.Trip = trip
					set unifiedEvent1.TripTime = travelTime
					set unifiedEvent2.TripTime = travelTime
					set unifiedEvent3.TripTime = travelTime
					
					If (lastUnifiedEvent.EventDateTime '= ""){
						set lastUnifiedEvent.Duration = $System.SQL.DATEDIFF("second", lastUnifiedEvent.EventDateTime, unifiedEvent1.EventDateTime)
						If (lastUnifiedEvent.StatusEvent.StatusType.Description '= "Operative"){
							set lastUnifiedEvent.OperativeDuration = 0
						} else {
							set lastUnifiedEvent.OperativeDuration = lastUnifiedEvent.Duration
						}
					}
					set unifiedEvent1.StatusEvent = lastUnifiedEvent.StatusEvent 
					set unifiedEvent2.StatusEvent = lastUnifiedEvent.StatusEvent 
					set unifiedEvent3.StatusEvent = lastUnifiedEvent.StatusEvent 

					
					set sc = lastUnifiedEvent.%Save()
				}
				set equipment.LastUnifiedEvent = unifiedEvent3
				set sc = equipment.%Save()

				set sc = ..SendRequestAsync("PowerView Operation", productionEvent1)
				set sc = ..SendRequestAsync("PowerView Operation", productionEvent2)
				set sc = ..SendRequestAsync("PowerView Operation", productionEvent3)
				set sc = ..SendRequestAsync("PowerView Operation", unifiedEvent1)
				set sc = ..SendRequestAsync("PowerView Operation", unifiedEvent2)
				set sc = ..SendRequestAsync("PowerView Operation", unifiedEvent3)		
											
			} else {
				$$$TRACE("Dump event already exists "_oRS.Get("index2")_"...")
			}
		} elseif (oRS.Get("timeload") '= "") {
			//$$$TRACE("Processing Loads events not implemented yet")
			Set tLoadLastKey = oRS.Get("index2")
			
			If '##class(ASPMining.CanonicalModel.Production.LoadEvent).LoadIndexExists(oRS.Get("index2")){
				set shiftindex = oRS.Get("shiftindex")
				set truck = oRS.Get("truck")
				set excav = oRS.Get("excav")
				set loadindex = oRS.Get("loadrec")
				set location = oRS.Get("loc")
				
				set timearrive = oRS.Get("timearrive")
				set timeload = oRS.Get("timeload")
				set timefull = oRS.Get("timefull")
				set measuretons = oRS.Get("measureton")
				
				set shift = ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexOpen(shiftindex)
				set equipment = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(truck)
			
				$$$TRACE("Load event does not exists "_oRS.Get("index2")_"...")
				set oLoad = ##class(ASPMining.CanonicalModel.Production.LoadEvent).%New()
				#Dim oDump As ASPMining.CanonicalModel.Production.LoadEvent
				
				set shiftindex = oRS.Get("shiftindex")
				set truck = oRS.Get("truck")
				set excav = oRS.Get("excav")
				set loadindex = oRS.Get("loadrec")
												
				set oLoad.LoadId = oRS.Get("index2")
				set oLoad.MeasuredTons = oRS.Get("measureton")
				//set oDump.TravelTime = oRS.Get("calctravti")
				// check shift
				if '##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(shiftindex){
					$$$TRACE("ERROR IN LOAD: SHIFT DOES NOT EXISTS: "_shiftindex)
				}else{
					set shift = ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexOpen(shiftindex)	
					set oLoad.Shift = shift	
					$$$TRACE("Load Shift StartSeconds "_shift.StartSeconds)
					$$$TRACE("Load TimeArrive "_timearrive)	
					$$$TRACE("Load TimeLoad "_timeload)	
					$$$TRACE("Load TimeFull "_timefull)	
					
					set oLoad.TimeArrive = ..ShiftOffsetToDateTime(timearrive, shiftindex)
					set oLoad.TimeLoad = ..ShiftOffsetToDateTime(timeload, shiftindex)
					set oLoad.TimeFull = ..ShiftOffsetToDateTime(timefull, shiftindex)
					$$$TRACE("LOAD TimeArrive: "_oLoad.TimeArrive)
				}
				
				// check truck
				if '##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexExists(truck){
					$$$TRACE("ERROR IN LOAD: TRUCK DOES NOT EXISTS: "_truck)
				} else {
					set oLoad.EquipmentTruck = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(truck)
					set lastLoadId = oLoad.%Id()
					$$$TRACE("Last LOAD ID: if none, no persistent, must be done after save "_lastLoadId)
				}
				// check excav
				if '##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexExists(excav){
					$$$TRACE("ERROR IN LOAD: EXCAV DOES NOT EXISTS: "_excav)
				} else {
					set oLoad.EquipmentExcav = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(excav)
				}
				
				// check locations
				if '##class(ASPMining.CanonicalModel.Mine.Location).NameIndexExists(location){
					$$$TRACE("LOAD: LOC DOES NOT EXISTS: "_location)
					set oLoad.Location = ##class(ASPMining.CanonicalModel.Mine.Location).%New()
					set oLoad.Location.Name = location
					set oLoad.Location.Grade = oRS.Get("grade")
				} else {
					set oLoad.Location = ##class(ASPMining.CanonicalModel.Mine.Location).NameIndexOpen(location)
				}
				//check load
				//if '##class(ASPMining.CanonicalModel.Production.LoadEvent).LoadIndexExists()
				
				
				
				set sc = ..SendRequestAsync("PowerView Operation", oLoad)
				// Hasta aqui todo tablas estandard
				// ************************
				// Desde Aqui nuevo unified para oee
				
	
				$$$TRACE("LOAD: Generating New Production Events")
				//TODO: add "grade" to location if it doesnt exists
				// debo crear 3  productionevent con tipo transit to dump, waiting to dump, dump con su correspondiente unified event.
				set productionEvent1 = ##class(ASPMining.CanonicalModel.Production.ProductionEvent).%New()
				set productionEvent1.Id = uniqueId+3
				set productionEvent1.Equipment = equipment
				set productionEvent1.ProductionStatusType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).TypeIndexOpen(5) //waiting to load
				set productionEvent1.Location = ##class(ASPMining.CanonicalModel.Mine.Location).NameIndexOpen(location)
				set productionEvent1.Shift = shift
				set productionEvent1.StartTime = ..ShiftOffsetToDateTime(timearrive, shiftindex)
				set productionEvent1.MeasuredTons = measuretons
				
				
				set productionEvent2 = ##class(ASPMining.CanonicalModel.Production.ProductionEvent).%New()
				set productionEvent2.Id = uniqueId+4
				set productionEvent2.Equipment = equipment
				set productionEvent2.ProductionStatusType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).TypeIndexOpen(6) //loading
				set productionEvent2.Location = ##class(ASPMining.CanonicalModel.Mine.Location).NameIndexOpen(location)
				set productionEvent2.Shift = shift
				set productionEvent2.StartTime = ..ShiftOffsetToDateTime(timeload, shiftindex)
				set productionEvent2.MeasuredTons = measuretons
				//update previous production event
				set productionEvent1.Duration = $System.SQL.DATEDIFF("second", productionEvent1.StartTime , productionEvent2.StartTime)
				
				
				set productionEvent3 = ##class(ASPMining.CanonicalModel.Production.ProductionEvent).%New()
				set productionEvent3.Id = uniqueId+5
				set productionEvent3.Equipment = equipment
				set productionEvent3.ProductionStatusType = ##class(ASPMining.CanonicalModel.Production.ProductionStatusType).TypeIndexOpen(1) //transit to dump
				set productionEvent3.Location = ##class(ASPMining.CanonicalModel.Mine.Location).NameIndexOpen(location)
				set productionEvent3.Shift = shift
				set productionEvent3.StartTime = ..ShiftOffsetToDateTime(timefull, shiftindex)
				set productionEvent3.MeasuredTons = measuretons
				//update previous production event
				set productionEvent2.Duration = $System.SQL.DATEDIFF("second", productionEvent2.StartTime , productionEvent3.StartTime)
				
				
				$$$TRACE("LOAD: Generating New Unified Events")
				
				set unifiedEvent1 = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).%New()
				set unifiedEvent1.Id = uniqueId+3
				set unifiedEvent1.Equipment = equipment
				set unifiedEvent1.Shift = shift
				set unifiedEvent1.ProductionEvent = productionEvent1 
				set unifiedEvent1.EventDateTime = productionEvent1.StartTime 
				//update previous unified event
				
				set unifiedEvent2 = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).%New()
				set unifiedEvent2.Id = uniqueId+4
				set unifiedEvent2.Equipment = equipment
				set unifiedEvent2.Shift = shift
				set unifiedEvent2.ProductionEvent = productionEvent2 
				set unifiedEvent2.EventDateTime = productionEvent2.StartTime 
				//update previous unified event
				set unifiedEvent1.Duration = $System.SQL.DATEDIFF("second", unifiedEvent1.EventDateTime, unifiedEvent2.EventDateTime)
				set unifiedEvent1.OperativeDuration = unifiedEvent1.Duration
				
				set unifiedEvent3 = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).%New()
				set unifiedEvent3.Id = uniqueId+5
				set unifiedEvent3.Equipment = equipment
				set unifiedEvent3.Shift = shift
				set unifiedEvent3.ProductionEvent = productionEvent3 
				set unifiedEvent3.EventDateTime = productionEvent3.StartTime 
				set unifiedEvent3.Duration = 0 
				//update previous unified event
				set unifiedEvent2.Duration = $System.SQL.DATEDIFF("second", unifiedEvent2.EventDateTime, unifiedEvent3.EventDateTime)
				set unifiedEvent2.OperativeDuration = unifiedEvent2.Duration

								
				set lastTrackUEvent = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(truck).LastUnifiedEvent
				If ( lastTrackUEvent '= ""){

					set lastUnifiedEvent = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).IdIndexOpen(lastTrackUEvent.Id)
					
					If (lastUnifiedEvent.ProductionEvent '= ""){
						set lastUnifiedEvent.ProductionEvent.Duration = $System.SQL.DATEDIFF("second", lastUnifiedEvent.ProductionEvent.StartTime , productionEvent1.StartTime)
					}

					set productionEvent1.PreviousLocation = lastUnifiedEvent.ProductionEvent.Location
					set productionEvent2.PreviousLocation = lastUnifiedEvent.ProductionEvent.Location
					set productionEvent3.PreviousLocation = lastUnifiedEvent.ProductionEvent.Location

					// Update trip information:
					set tripId = productionEvent1.PreviousLocation.Name_"-"_productionEvent1.Location.Name
					If ('##class(ASPMining.CanonicalModel.Mine.Trip).IdIndexExists(tripId)){
						
						//this is the time between last production event and current production event, so for KPI puropses, the non operative time must be substracted
						set travelTime = productionEvent1.Duration 

						set trip = ##class(ASPMining.CanonicalModel.Mine.Trip).%New()
						#Dim trip as ASPMining.CanonicalModel.Mine.Trip
						set trip.Id = tripId
						set trip.Name = productionEvent1.PreviousLocation.Name_" to "_productionEvent1.Location.Name
						set trip.OriginLocation = productionEvent1.PreviousLocation
						set trip.DestinationLocation = productionEvent1.Location
						set trip.ReferenceTravelTime = travelTime
						set trip.MinTravelTime = travelTime
						set trip.MaxTravelTime = travelTime
						set trip.TravelCount = 1
						set trip.TotalTravelTime = travelTime
						set trip.AvgTravelTime = trip.TotalTravelTime / trip.TravelCount
					} else {
						set travelTime = productionEvent1.Duration 

						set trip = ##class(ASPMining.CanonicalModel.Mine.Trip).IdIndexOpen(tripId)
						#Dim trip as ASPMining.CanonicalModel.Mine.Trip
						If (travelTime < trip.MinTravelTime){
							set trip.MinTravelTime = travelTime
						}
						If (travelTime > trip.MaxTravelTime){
							set trip.MaxTravelTime = travelTime
						}
						set trip.ReferenceTravelTime = (trip.MinTravelTime  + trip.MaxTravelTime) / 2
						set trip.TravelCount = trip.TravelCount + 1
						set trip.TotalTravelTime = trip.TotalTravelTime + travelTime
						set trip.AvgTravelTime = trip.TotalTravelTime / trip.TravelCount
					}
					// save the trip right now to dont wait for the operation
					// add this trip to the unified event
					set sc = trip.%Save()
					set unifiedEvent1.Trip = trip
					set unifiedEvent2.Trip = trip
					set unifiedEvent3.Trip = trip
					set unifiedEvent1.TripTime = travelTime
					set unifiedEvent2.TripTime = travelTime
					set unifiedEvent3.TripTime = travelTime

					If (lastUnifiedEvent.EventDateTime '= ""){
						set lastUnifiedEvent.Duration = $System.SQL.DATEDIFF("second", lastUnifiedEvent.EventDateTime, unifiedEvent1.EventDateTime)
						
						If (lastUnifiedEvent.StatusEvent.StatusType.Description '= "Operative"){
							set lastUnifiedEvent.OperativeDuration = 0
						} else {
							set lastUnifiedEvent.OperativeDuration = lastUnifiedEvent.Duration
						}
					}
					set unifiedEvent1.StatusEvent = lastUnifiedEvent.StatusEvent 
					set unifiedEvent2.StatusEvent = lastUnifiedEvent.StatusEvent 
					set unifiedEvent3.StatusEvent = lastUnifiedEvent.StatusEvent 
					
					set sc = lastUnifiedEvent.%Save()
				}
				set equipment.LastUnifiedEvent = unifiedEvent3
				set sc = equipment.%Save()


				set sc = ..SendRequestAsync("PowerView Operation", productionEvent1)
				set sc = ..SendRequestAsync("PowerView Operation", productionEvent2)
				set sc = ..SendRequestAsync("PowerView Operation", productionEvent3)
				set sc = ..SendRequestAsync("PowerView Operation", unifiedEvent1)
				set sc = ..SendRequestAsync("PowerView Operation", unifiedEvent2)
				set sc = ..SendRequestAsync("PowerView Operation", unifiedEvent3)	
			} else {

				$$$TRACE("Load event already exists "_oRS.Get("index2")_"...")
			}
			
		} elseif (oRS.Get("eqmt") '= "") {
			$$$TRACE("Processing Status Only Unified WITHOUT Slicing")
			Set tStatusLastKey = oRS.Get("index2")
			
			set shiftindex = oRS.Get("shiftindex")
			set truck = oRS.Get("eqmt")
			set reason = oRS.Get("reason")
			set statustype = oRS.Get("status")
			set timearrive = oRS.Get("timearrive") //en relaidad se llamaba starttime pero se rneombro en la query para tener menos columnas
			set duration = oRS.Get("delta") //en relaidad se llamaba duration pero se renombro en la query para tener menos columnas

					
		
			set shift = ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexOpen(shiftindex)
			set equipment = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(truck)
			
			set statusEvent = ##class(ASPMining.CanonicalModel.Operation.StatusEvent).%New()
			set statusEvent.Id = uniqueId+6
			set statusEvent.Equipment = equipment
			set reasonindex = statustype_ "-" _reason
			$$$TRACE("STATUS: Generating New Unified Events: "_statustype_ "-"_reason)
			set statusEvent.StatusReason = ##class(ASPMining.CanonicalModel.Operation.StatusReason).IdIndexOpen(reasonindex)
			set statusEvent.StatusType = ##class(ASPMining.CanonicalModel.Operation.StatusType).TypeIndexOpen(statustype)
			set statusEvent.Shift = shift
			set statusEvent.StartDate = ..ShiftOffsetToDateTime(timearrive, shiftindex)
			//TODO: Verificar que timearrive + duration no se pasa del dia
			set statusEvent.EndDate = ..ShiftOffsetToDateTime(timearrive + duration, shiftindex)
			//status events duration comes in same row so dont need to update the previous one also
			set statusEvent.Duration = duration 
			
			set sc = ..SendRequestAsync("PowerView Operation", statusEvent)
			
			$$$TRACE("STATUS: Generating New Unified Events")
			
			set unifiedEvent1 = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).%New()
			set unifiedEvent1.Id = uniqueId+6
			set unifiedEvent1.Equipment = equipment
			set unifiedEvent1.Shift = shift
			set unifiedEvent1.StatusEvent = statusEvent
			set unifiedEvent1.EventDateTime = statusEvent.StartDate 
			set unifiedEvent1.Duration = 0 

			set lastTrackUEvent = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(truck).LastUnifiedEvent
			If ( lastTrackUEvent '= ""){

				set lastUnifiedEvent = ##class(ASPMining.CanonicalModel.Operation.UnifiedEvents).IdIndexOpen(lastTrackUEvent.Id)
				
				set unifiedEvent1.ProductionEvent = lastUnifiedEvent.ProductionEvent 
				set unifiedEvent1.Trip = lastUnifiedEvent.Trip
				set unifiedEvent1.TripTime = lastUnifiedEvent.TripTime

				// TODO: check if we can remove this check here and do this directly into the cube
				If (unifiedEvent1.StatusEvent.StatusType.Description '= "Operative"){
					set unifiedEvent1.OperativeDuration = 0
				} else {
					set unifiedEvent1.OperativeDuration = unifiedEvent1.Duration
				}


				// Update duration
				If (lastUnifiedEvent.EventDateTime '= ""){
					set lastUnifiedEvent.Duration = $System.SQL.DATEDIFF("second", lastUnifiedEvent.EventDateTime, unifiedEvent1.EventDateTime)

					If (lastUnifiedEvent.StatusEvent.StatusType.Description '= "Operative"){
						set lastUnifiedEvent.OperativeDuration = 0
					} else {
						set lastUnifiedEvent.OperativeDuration = lastUnifiedEvent.Duration
					}
				}

				set sc = lastUnifiedEvent.%Save()
			}

			set equipment.LastUnifiedEvent = unifiedEvent1
			set sc = equipment.%Save()

			set sc = ..SendRequestAsync("PowerView Operation", unifiedEvent1)

			//
			// JUST FOR GETTING THE SPLICES
			// OLD FUNCTIONALITY COMPLETE EVENTS
			$$$TRACE("Processing event index2 "_tStatusLastKey_"...")
			
			/// oRS.Get Names must match SQL query var names
			set oEvent = ##class(ASPMining.ConnectorModules.BO.CompleteEvent).%New()
			#Dim oEvent As ASPMining.ConnectorModules.BO.CompleteEvent
			
			set oEvent.EquipmentId = truck // TODO: Asegurar que se tiene este id en la table Equipment
			//ASK Amir how to do this. if('##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(oEvent.ShiftId))
			
			// TODO: MISSING HIST_SHIFT_INDEX. Hardcoded time provided for testing, should consider the initial offset time provided by the shift index table.
			set oEvent.ShiftId = shiftindex
			set oEvent.Duration = duration
			
			if ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexExists(oEvent.ShiftId){
				set shift = ##class(ASPMining.CanonicalModel.Planning.Shift).ShiftIndexOpen(oEvent.ShiftId)		
				$$$TRACE("LOG1 StartSeconds "_shift.StartSeconds_",starttime: "_timearrive)	
				
				//Checking if starttime is within same day or next day, this could happen since shifts belong to more than 1 day
				set startseconds = shift.StartSeconds + timearrive
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
				$$$TRACE("EVENT StartTimeDT "_oEvent.StartDate_",StartTime: "_timearrive_ " Duration: "_oEvent.Duration)
				
				
				//Checking if endtime is within same day or next day, just like with start time
				set endseconds = shift.StartSeconds + timearrive + oEvent.Duration
				set endday = 0 //used for splicing only
				$$$TRACE("endseconds: "_endseconds)
				If (endseconds) >= 86400 {
					set nextday = shift.StartDay + ##class(%Library.Integer).Normalize(endseconds / 86400) //TODO: CHECK IF EVENT THAT ENDS IN END OF SHIFT OR IN MANY DAYS LATER, EASY: CHECK IF ANY DURTION LONGER THAN 86400
					set newendseconds = endseconds # 86400
					$$$TRACE("newendseconds "_newendseconds_" endseconds "_endseconds_ " nextday "_nextday)
					set endday = nextday
					set oEvent.EndDate = $ZDateTime(nextday_","_newendseconds)
				} else {
					set endday = shift.StartDay
					set oEvent.EndDate = $ZDateTime(shift.StartDay_","_endseconds)
				}
				$$$TRACE("EVENT EndTime "_oEvent.EndDate_"...")
				
				set oEvent.StatusReasonId = reason
				set oEvent.StatusTypeId = statustype
				
				$$$TRACE("StatusReasonId "_oEvent.StatusReasonId_"...")
							
				//Set ..%SessionId=""
				
				//set sc = ..SendRequestAsync("PowerView Operation", oEvent)
				
				// SLICING OF THE EVENT
				// Slice the event into fixed length pieces
				set SliceDuration = 300 //5 minutes slices
				
				set firstSliceSlotOffset = newstartseconds # SliceDuration // ej: if i'm at seconds 1534, returns 34 sobran 60
				set firstSliceSlot = newstartseconds - firstSliceSlotOffset // gets the start of the slice slot, e.g: 1500
				set lastSliceSlotOffset = (newstartseconds + duration ) # SliceDuration // sobran 154
				set lastSliceSlot = (newstartseconds + duration ) - lastSliceSlotOffset
				
				set firstSliceRemainingTime = SliceDuration - firstSliceSlotOffset
				set lastSliceRemainingTime = SliceDuration - lastSliceSlotOffset
				
				// Checks if this events ends in the next window or it ends in the same time window
				set extraSliceCount = ##class(%Library.Integer).Normalize((lastSliceSlot - firstSliceSlot)/SliceDuration)
				
				If ((lastSliceSlot - firstSliceSlot) >= 300){ //only checks if the duration of the event is 1 or more slot spans
					// slice in pieces
					$$$TRACE("EXTRA SLICES on event with ddbkey "_oRS.Get("ddbkey")_" sliceCount: "_extraSliceCount_" firstsliceseconds: "_firstSliceSlot_" startday: "_startday)

					//send fraction of first slot
					set oSliceEvent = ##class(ASPMining.ConnectorModules.BO.SlicedEvent).%New()
					set oSliceEvent.ddbkey = tStatusLastKey
					set oSliceEvent.EquipmentId = truck
					set oSliceEvent.ShiftId = shiftindex
					set oSliceEvent.StatusReasonId = statustype_ "-" _reason
					set oSliceEvent.StatusTypeId = statustype
					set oSliceEvent.SliceStartDate = $ZDateTime(startday_","_firstSliceSlot)
					set oSliceEvent.PartialDuration = firstSliceRemainingTime / SliceDuration //this event is longer than a single slot so is has the whole remaining time of the first slot

					$$$TRACE("MULTI SLICE first PartialDuration: "_oSliceEvent.PartialDuration) //
					set sc = ..SendRequestAsync("PowerView Operation", oSliceEvent) // maybe new operation?
					
					For i=1:1:extraSliceCount {
						//$$$TRACE("EXTRA SLICE i: "_i) //
						set oSliceEvent = ##class(ASPMining.ConnectorModules.BO.SlicedEvent).%New()
						set oSliceEvent.ddbkey = tStatusLastKey
						set oSliceEvent.EquipmentId = truck
						set oSliceEvent.ShiftId = shiftindex
						set oSliceEvent.StatusReasonId = statustype_ "-" _reason
						set oSliceEvent.StatusTypeId = statustype
						// validate the day we are before anything
						set thisSlotSeconds = firstSliceSlot + (i * SliceDuration)
						If (thisSlotSeconds >= 84600) {
							// Will always be only 1 more day if the shifts are 12h or less (considering timezone diff
							set nextday = startday + ##class(%Library.Integer).Normalize(thisSlotSeconds / 86400)
							set oSliceEvent.SliceStartDate = $ZDateTime(nextday_","_(thisSlotSeconds # 86400))
							$$$TRACE("NEXT SLOT StartTime: "_(thisSlotSeconds # 86400))
						} else {
							set oSliceEvent.SliceStartDate = $ZDateTime(startday_","_thisSlotSeconds)
						}
						
						//check if last slot
						If (i = extraSliceCount) {
							set oSliceEvent.PartialDuration = lastSliceSlotOffset / SliceDuration
						} else { //is middle slot
							set oSliceEvent.PartialDuration = 1.0
						}
						$$$TRACE("EXTRA SLICE i: "_i_" PartialDuration: "_oSliceEvent.PartialDuration) //
						set sc = ..SendRequestAsync("PowerView Operation", oSliceEvent) // maybe new operation?
					}
					
				} else {
					set oSliceEvent = ##class(ASPMining.ConnectorModules.BO.SlicedEvent).%New()
					set oSliceEvent.ddbkey = tStatusLastKey
					set oSliceEvent.EquipmentId = truck
					set oSliceEvent.ShiftId = shiftindex
					set oSliceEvent.StatusReasonId = statustype_ "-" _reason
					set oSliceEvent.StatusTypeId = statustype
					set oSliceEvent.SliceStartDate = $ZDateTime(startday_","_firstSliceSlot)
					set oSliceEvent.PartialDuration = (firstSliceRemainingTime - lastSliceRemainingTime) / SliceDuration
					$$$TRACE("SINGLE SLICE ddbkey: "_oSliceEvent.ddbkey_" PartialDuration: "_oSliceEvent.PartialDuration) //
					set sc = ..SendRequestAsync("PowerView Operation", oSliceEvent) // maybe new operation?
				}
				
			} else {
				$$$TRACE("Skipping event due to: ShiftIndex "_oEvent.ShiftId_" Does not exists for StatusEventId tStatusLastKey: "_tStatusLastKey)
			}

		} else {
			$$$TRACE("Invalid event received, not valid timedump, or timeload, or eqmt")
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "UnifiedLastDumpKey", tDumpLastKey)
		Do ..Adapter.SetPersistentValue(..%ConfigName, "UnifiedLastLoadKey", tLoadLastKey)
		Do ..Adapter.SetPersistentValue(..%ConfigName, "UnifiedLastStatusKey", tStatusLastKey)
	}
}

Method SaveLastSliceOfTruck(truckId As %String, lastUpdateSlice As ASPMining.CanonicalModel.Production.ProductionEventSliced)
{
	set truck = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(truckId)
	set truck.LastProductionUpdate = lastUpdateSlice
	Set sc2 = truck.%Save()
}

Method ShiftOffsetToDateTime(offset As %Integer, shiftindex As %Integer)
{
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
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastLoadSliceKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastDumpSliceKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "UnifiedLastDumpKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "UnifiedLastLoadKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "UnifiedLastStatusKey", 0)
   /// lAST eVENT KEY IS A TIMESTAMP KEY
   /// Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey", $ZDateTime("0,0", 3))
   /// Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastCompletedDumpKey",0)
   Quit $$$OK
}

}
