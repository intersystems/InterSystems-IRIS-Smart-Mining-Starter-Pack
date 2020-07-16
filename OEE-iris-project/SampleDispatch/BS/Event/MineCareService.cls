Class SampleDispatch.BS.Event.MineCareService Extends Ens.BusinessService
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
		Do ..ProcessNewModels()
		//SELECT TOP 1000 * FROM [EqmtModel] // Id, Name, Manufacturer, Description
		Do ..ProcessNewCategories()
		//SELECT TOP 1000 * FROM [EqmtGroup] // Id, Name, Description
		Do ..ProcessNewEquipments() //gets equipment, groups and models
		//SELECT TOP 1000 * FROM [EquipmentUnit] //Id, Name, ModelId, GroupId, Tonnage. // no: FleetId, CategoryId
		//Do ..ProcessOEMEventTypes()

		Do ..ProcessOEMEvent()
		
	}
	Catch(oException)
	{
		Set sc = oException.AsStatus()
	}
	
	Quit sc
}

Method ProcessNewModels()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastModelKey")
	$$$TRACE("MC Next equipment Model event Id "_tLastKey_"...")
	
	/// Gets all the new received events where equipment is involved, infer form here which ones are new
	Set tQueryStatement="SELECT Id, Name, Manufacturer, Description FROM  dbo.EqmtModel WHERE Id>? ORDER BY cast(Id as int) ASC"

	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("Id")
		$$$TRACE("MC - Processing equipment Id "_tLastKey_"...")
		
		If '##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).EquipmentModelIndexExists(oRS.Get("Id")){
			$$$TRACE("MC - Equipment Model not exists "_oRS.Get("Id")_"...")
			set oEquipment = ##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).%New()
			#Dim oEquipment As ASPMining.CanonicalModel.Equipment.EquipmentModel
			
			set oEquipment.Model = oRS.Get("Id")
			set oEquipment.Brand = oRS.Get("Manufacturer")
			set oEquipment.Description = oRS.Get("Name")
			
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Event Operation", oEquipment)
		}else{
			$$$TRACE("MC - Model already exists "_oRS.Get("Id")_"...")
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastModelKey", tLastKey)
	}
}

Method ProcessNewCategories()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastCategoryKey")
	$$$TRACE("MC Next equipment Category event Id "_tLastKey_"...")
	
	/// Gets all the new received events where equipment is involved, infer form here which ones are new
	Set tQueryStatement="SELECT Id, Name, Description FROM dbo.EqmtGroup  WHERE Id>? ORDER BY cast(Id as int) ASC"

	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("Id")
		$$$TRACE("MC - Processing equipment Id "_tLastKey_"...")
		
		If '##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).EquipmentCategoryIndexExists(oRS.Get("Id")){
			$$$TRACE("MC - Equipment Category does not exists "_oRS.Get("Id")_"...")
			set oEquipment = ##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).%New()
			#Dim oEquipment As ASPMining.CanonicalModel.Equipment.EquipmentCategory
			
			set oEquipment.Name = oRS.Get("Id")
			set oEquipment.Description = oRS.Get("Name")
			
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Event Operation", oEquipment)
		}else{
			$$$TRACE("MC - Category already exists "_oRS.Get("Id")_"...")
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastCategoryKey", tLastKey)
	}
}

Method ProcessNewEquipments()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastEquipmentKey")
	$$$TRACE("Next equipment event Id "_tLastKey_"...")
	
	/// Gets all the new received events where equipment is involved, infer form here which ones are new
	Set tQueryStatement="SELECT Id, Name, ModelId, GroupId, Tonnage FROM dbo.EquipmentUnit WHERE Id>? ORDER BY cast(Id as int) ASC"
	//SELECT MIN(ddbkey) as ddbkey, eqmtid, MAX(size) as size, MAX(eqmttype#) as eqmttype#, MAX(eqmttype) as eqmttype, MAX(unit) as unit FROM dbo.hist_eqmtlist GROUP BY eqmtid

	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("Id")
		$$$TRACE("MC - Processing equipment Id "_tLastKey_"...")
		
		If '##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexExists(oRS.Get("Id")){
			$$$TRACE("MC - Equipment not exists "_oRS.Get("Id")_"...")
			set oEquipment = ##class(ASPMining.CanonicalModel.Equipment.Equipment).%New()
			#Dim oEquipment As ASPMining.CanonicalModel.Equipment.Equipment
			
			set groupId = oRS.Get("GroupId")
			set ModelId = oRS.Get("ModelId")

			set oEquipment.Id = oRS.Get("Id")
			set oEquipment.Name = oRS.Get("Name")
			set oEquipment.Capacity = oRS.Get("Tonnage")

			// If equipment category didnt exits, create a generated one (but it should have existed one form previous queries)
			If '##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).EquipmentCategoryIndexExists(groupId){
				set oEquipment.EquipmentCategory = ##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).%New() //TODO: obtener antes las eqmttype
				set oEquipment.EquipmentCategory.Name = groupId
				set oEquipment.EquipmentCategory.Description = "Generated by MC Service"
			} else {
				set oEquipment.EquipmentCategory = ##class(ASPMining.CanonicalModel.Equipment.EquipmentCategory).EquipmentCategoryIndexOpen(groupId)
			}
			set oEquipment.Name = oEquipment.EquipmentCategory.Description_" - "_oEquipment.Name
			
			//  If equipment model didnt exits, create a generated one (but it should have existed one form previous queries)
			If '##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).EquipmentModelIndexExists(ModelId){
				set oEquipment.EquipmentModel = ##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).%New() //TODO: obtener antes las eqmttype
				set oEquipment.EquipmentModel.Model = ModelId
				set oEquipment.EquipmentModel.Brand = "IRIS"
				set oEquipment.EquipmentModel.Description = "Generated by MC Service"
			}else{
				set oEquipment.EquipmentModel = ##class(ASPMining.CanonicalModel.Equipment.EquipmentModel).EquipmentModelIndexOpen(ModelId)
			}
			
			
			Set ..%SessionId=""
			
			set sc = ..SendRequestAsync("PowerView Event Operation", oEquipment)
		}else{
			$$$TRACE("MC - Equipment already exists "_oRS.Get("Id")_"...")
		}
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastEquipmentKey", tLastKey)
	}
}

/// We will only bring dumps that are COMPLETE. So we are querying for all NEW dumps that have a non null EndTime
Method ProcessOEMEvent()
{
	#Dim oRS As EnsLib.SQL.GatewayResultSet
	
	Set tLastKey = ..Adapter.GetPersistentValue(..%ConfigName, "LastOEMEventKey")
	$$$TRACE("Next OEM event Id "_tLastKey_"...")
	
	/// Gets all the new received events
	Set tQueryStatement="SELECT Id, EquipmentId, OemEventTypeId, ReadTime, FloatValue FROM dbo.OemEventValue WHERE Id>?"
						
						
	Set sc = ..Adapter.ExecuteQuery(.oRS, tQueryStatement, tLastKey)
	
	While oRS.Next()
	{
		Set tLastKey = oRS.Get("Id")
		$$$TRACE("Processing OEM event Id "_tLastKey_"...")
		
		#Dim oEvent as ASPMining.CanonicalModel.HWMonitoring.OEMEvent
		/// oRS.Get Names must match SQL query var names
		set oEvent = ##class(ASPMining.CanonicalModel.HWMonitoring.OEMEvent).%New()
		//set oEvent.EquipmentId = oRS.Get("EquipmentId") //get the real equipment

		set equipmentId = oRS.Get("EquipmentId")

		set oEvent.Id = oRS.Get("Id") //get the real equipment
		set readtime = oRS.Get("ReadTime")
		set oEvent.Value = oRS.Get("FloatValue")
		set oEvent.ReadTime = $ZDateTime($ZDATETIMEH(readtime, 3))

		// TODO: validate equipment exists
		set oEvent.Equipment = ##class(ASPMining.CanonicalModel.Equipment.Equipment).EquipmentIndexOpen(equipmentId)
		
		// TODO: GET event type

		Set ..%SessionId=""
		
		set sc = ..SendRequestAsync("PowerView Event Operation", oEvent)
		
		Do ..Adapter.SetPersistentValue(..%ConfigName, "LastOEMEventKey", tLastKey)
	}
}

Method OnInit() As %Status
{
   #; initialize persistent last key value
   //Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey",0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastOEMEventKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEquipmentKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastCategoryKey", 0)
   Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastModelKey", 0)
   /// lAST eVENT KEY IS A TIMESTAMP KEY
   /// Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastEventKey", $ZDateTime("0,0", 3))
   /// Do ..Adapter.InitializePersistentValue(..%ConfigName, "LastCompletedDumpKey",0)
   Quit $$$OK
}

}
