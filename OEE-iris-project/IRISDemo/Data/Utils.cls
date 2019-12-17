Include DEMOMACROS

Class IRISDemo.Data.Utils
{

ClassMethod LoadData()
{
		Do ..LoadItemMaster()
		
		Do ..LoadProductionOrderChanges()
		
		Do ..LoadProductionCounts()
		
		Do ..LoadWasteCounts()
		
		Do ..LoadDowntimeEvents()
		
		Do ..ConfigEnvironment()


}


ClassMethod LoadItemMaster()
{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute("/tmp/ItemMaster.csv") 
		$$$ThrowStatusExceptionIfError(tSC, "LoadItemMasterFileException")
		
		While objRs.Next() 
		{
			Do ..CreateItemMaster(objRs.Get("ItemCode"), objRs.Get("ItemRate"))
		}
}

ClassMethod CreateItemMaster(pItemCode As %String, pItemRate As %Integer)
{
		set obj = ##class(IRISDemo.Data.ItemMaster).%New()
		
		Set obj.ItemCode = pItemCode
		Set obj.ItemRate = pItemRate
		
		Set tSC = obj.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "ItemMasterSaveException")
}

ClassMethod LoadProductionOrderChanges()
{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute("/tmp/ProductionOrderChanges.csv") 
		$$$ThrowStatusExceptionIfError(tSC, "LoadItemMasterFileException")
		
		While objRs.Next() 
		{
			set obj = ##class(IRISDemo.Data.ProductionOrderChange).%New()
			
			Set obj.StartTime = ..FixTimeStamp(objRs.Get("StartTime"))
			Set obj.EndTime = ..FixTimeStamp(objRs.Get("EndTime"))
			Set obj.ProductionOrder = objRs.Get("ProductionOrder")
			Set obj.ItemMaster = ##class(IRISDemo.Data.ItemMaster).ItemCodeIndexOpen(objRs.Get("ItemCode"))
			
			If obj.ItemMaster="" 
			{
				Write !!,"WARNING: ItemCode not found: "_objRs.Get("ItemCode")_". Creating ItemMaster",!!
				
				Do ..CreateItemMaster(objRs.Get("ItemCode") , -1)
				
				Set obj.ItemMaster = ##class(IRISDemo.Data.ItemMaster).ItemCodeIndexOpen(objRs.Get("ItemCode"))
			}
			
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "ProductionOrderChangesSaveException")
		}
}

ClassMethod LoadProductionCounts()
{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute("/tmp/ProductionCounts.csv") 
		$$$ThrowStatusExceptionIfError(tSC, "LoadProductionCountsFileException")
		
		While objRs.Next() 
		{
			set obj = ##class(IRISDemo.Data.ProductionCounts).%New()
			
			Set obj.StartTime = ..FixTimeStamp(objRs.Get("StartTime"))
			Set obj.EndTime = ..FixTimeStamp(objRs.Get("EndTime"))
			Set obj.ProductionCount = objRs.Get("ProductionCount")
			Set obj.ProductionOrder = ##class(IRISDemo.Data.ProductionOrderChange).FindByTimeInterval(obj.StartTime, obj.EndTime)
			
			If obj.ProductionOrder=""
			{
				Write !!,"WARNING: Could not find a production order change for loading this PRODUCTION for this time interval: '"_obj.StartTime_ "' and '"_obj.EndTime_"'"
				Write !,$Char(9),"Creating fake Production Order... "
				
				Set obj.ProductionOrder = ##class(IRISDemo.Data.ProductionOrderChange).CreateFake(obj.StartTime, obj.EndTime)
				
				If obj.ProductionOrder=""
				{
					Write "Could not create a fake one! Skipping this record.",!
					Continue
				}
				Else
				{
					Write "Done!",!
				}
			}
						
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "ProductionCountsSaveException")
			
			Set objTimeSlice = ##class(IRISDemo.Data.TimeSlice).%New()
			Set objTimeSlice.ProductionCounts = obj
			Set objTimeSlice.StartTime = obj.StartTime
			Set objTimeSlice.EndTime = obj.EndTime
			
			Set tSC = objTimeSlice.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "ProductionTimeSliceSaveException")
		}
}

ClassMethod LoadWasteCounts()
{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute("/tmp/WasteCounts.csv") 
		$$$ThrowStatusExceptionIfError(tSC, "LoadWasteCountsFileException")
		
		While objRs.Next() 
		{
			set obj = ##class(IRISDemo.Data.WasteCounts).%New()
			
			Set obj.StartTime = ..FixTimeStamp(objRs.Get("StartTime"))
			Set obj.EndTime = ..FixTimeStamp(objRs.Get("EndTime"))
			Set obj.WasteCount = +objRs.Get("WasteCount")
			Set obj.ProductionOrder = ##class(IRISDemo.Data.ProductionOrderChange).FindByTimeInterval(obj.StartTime, obj.EndTime)
			
			If obj.ProductionOrder=""
			{
				Write !!,"WARNING: Could not find a production order change for loading this WASTE for this time interval: '"_obj.StartTime_ "' and '"_obj.EndTime_"'",!!
				Write !,$Char(9),"Creating fake Production Order... "
				
				Set obj.ProductionOrder = ##class(IRISDemo.Data.ProductionOrderChange).CreateFake(obj.StartTime, obj.EndTime)
				
				If obj.ProductionOrder=""
				{
					Write "Could not create a fake one! Skipping this record.",!
					Continue
				}
				Else
				{
					Write "Done!",!
				}
			}
						
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "WasteCountsSaveException")
			
			Set objTimeSlice = ##class(IRISDemo.Data.TimeSlice).%New()
			Set objTimeSlice.WasteCounts = obj
			Set objTimeSlice.StartTime = obj.StartTime
			Set objTimeSlice.EndTime = obj.EndTime
			
			Set tSC = objTimeSlice.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "WasteTimeSliceSaveException")
		}
}

ClassMethod LoadDowntimeEvents()
{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

		Set tSC = objRs.Execute("/tmp/DowntimeEvents.csv") 
		$$$ThrowStatusExceptionIfError(tSC, "LoadDowntimeEventsFileException")
		
		Set iDowntimeCount=0
		While objRs.Next() 
		{
			Set iDowntimeCount=iDowntimeCount+1
			
			Set tOriginalStartTime = ..FixTimeStamp(objRs.Get("StartTime"))
			Set tOriginalEndTime = ..FixTimeStamp(objRs.Get("EndTime"))
			
			Set tReasonCode = objRs.Get("ReasonCode")
			
			set obj = ##class(IRISDemo.Data.DowntimeEvents).%New()
			
			Set obj.StartTime = tOriginalStartTime
			Set obj.EndTime = tOriginalEndTime
			Set obj.ReasonCode = tReasonCode
			
			
			Set obj.ProductionOrder = ##class(IRISDemo.Data.ProductionOrderChange).FindByTimeInterval(obj.StartTime, obj.EndTime)
			
			If obj.ProductionOrder=""
			{
				Write !!,"WARNING: Could not find a production order change for loading this DOWNTIME for this time interval: '"_obj.StartTime_ "' and '"_obj.EndTime_"'",!!
				Continue
			}
						
			Set tSC = obj.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "DowntimeEventsSaveException")

			// FRAGMENTATION into Time Slice table
			
			Set tTimeSliceStartTime = tOriginalStartTime
			Set bFinished=0
			Do 
			{
				Set tStartDate=$Piece(tTimeSliceStartTime, " ")
				Set tStartTime=$Piece(tTimeSliceStartTime, " ", 2)
				
				Set tNextHour=$Piece(tStartTime, ":")+1
				//If tNextHour=24 Set tNextHour="00"
				Set tNextTime=$S($L(tNextHour)=1:"0"_tNextHour, 1:tNextHour)_":00:00"
				Set tTimeSliceEndTime = tStartDate_" "_tNextTime
				
				If (tTimeSliceEndTime ]] tOriginalEndTime) || (tTimeSliceEndTime = tOriginalEndTime)
				{
					Set tTimeSliceEndTime = tOriginalEndTime
					Set bFinished = 1
				}
				
				Write !,"Fragmenting downtime "_iDowntimeCount_" between "_tTimeSliceStartTime_" and "_tTimeSliceEndTime
				
				Do ..CreateDowntimeEvent(obj, tTimeSliceStartTime, tTimeSliceEndTime, tReasonCode)
				
				Set tTimeSliceStartTime=tTimeSliceEndTime
			}
			While 'bFinished
		}
}

ClassMethod CreateDowntimeEvent(pDownTimeEvent As IRISDemo.Data.DowntimeEvents, pStartTime As %TimeStamp, pEndTime As %TimeStamp, pReasonCode As %String)
{
		
		Set objTimeSlice = ##class(IRISDemo.Data.TimeSlice).%New()
		Set objTimeSlice.DowntimeEvent = pDownTimeEvent
		Set objTimeSlice.StartTime = pStartTime
		Set objTimeSlice.EndTime = pEndTime
		
		Set tSC = objTimeSlice.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "DowntimeEventsTimeSliceSaveException")
}

ClassMethod FixTimeStamp(pCSVTimeStamp As %String) As %TimeStamp
{
		//KMB - adding ,,,6 to the $ZDATEH call to put the data in the 21st century
		//Can also be done by calling ##class(%SYS.NLS.Format).SetFormatItem("YearOption",6)
		//Should this be a new default?
		
		Set tDate = $ZDate($ZDateH($Piece(pCSVTimeStamp,"  "),,,6),3)
		Set tTime = $Piece(pCSVTimeStamp,"  ",2)
		Quit tDate_" "_tTime
}

ClassMethod ConfigEnvironment()
{
	do $SYSTEM.SQL.SetDefaultSchema("IRISDemo_Data")  //Sets a new default schema so we don't have to type it for every query
	s sc = ##class(%DeepSee.Utils).%BuildCube("Timeslice",1,0) //Build the TimeSlice cube
	$$$ThrowStatusExceptionIfError(sc,"TimeSliceBuildException")

}

}
