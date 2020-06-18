SELECT * FROM (
		SELECT TOP 500 cast(shiftindex as int) as shiftindex, (cast(shiftindex as bigint)*100000 + timearrive) AS index2, ddbkey, cast(timearrive as int) as timearrive, timedump, null as timeload,(cast(timeempty as int) - timearrive) as delta, timeempty, null as timefull, dumptons, null as loadtons
		 , truck, excav, loc, grade, bay, measureton, extraload 
		 FROM [hist_dumps] 
		 WHERE shiftindex <= 35063 AND extraload = '0'
		 ORDER BY shiftindex ASC, timearrive ASC 
	) AS A1   
     UNION 
     SELECT * FROM (
		SELECT TOP 500 cast(shiftindex as int) as shiftindex, (cast(shiftindex as bigint)*100000 + timearrive) AS index2, ddbkey, cast(timearrive as int) as timearrive, null as timedump, timeload,(cast(timefull as int) - timearrive) as delta, null as timeempty, timefull, null as dumptons, loadtons
		 , truck, excav, loc, grade, null as bay, measureton, extraload 
    	FROM [hist_loads] 
    	WHERE shiftindex <= 35063 AND extraload = '0'
    	ORDER BY shiftindex ASC, timearrive ASC  
    ) AS A2
    UNION 
     SELECT * FROM (
		SELECT TOP 500 cast(shiftindex as int) as shiftindex, (cast(shiftindex as bigint)*100000 + starttime) AS index2, ddbkey, cast(starttime as int) as timearrive, null as timedump, null as timeload, duration as delta, null as timeempty, null as timefull, null as dumptons, null as loadtons
		 , null as truck, null as excav, null as loc, null as grade, null as bay, null as measureton, null as extraload 
    	FROM [hist_statusevents] 
    	WHERE ddbkey > 0 and shiftindex <= 35063
    	ORDER BY shiftindex ASC, timearrive ASC  
    ) AS A3
     ORDER BY shiftindex ASC, timearrive, delta ASC 