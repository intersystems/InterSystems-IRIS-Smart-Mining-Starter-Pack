(() => {
  const angular = window.angular;

  Service.$inject = ['IrisUtils', '$filter', 'Utils'];

  angular
    .module('app')
    .service('LoadDump', Service);

  function Service(IrisUtils, $filter, Utils) {
    return {
      getDumpDetails,
      getLoadAndDumpEvents,
      getGanttData
    };

    function getDumpDetails(truckName, date) {
      const dateNumber = IrisUtils.getDateNumber(date);
      const minutes = date.getHours() * 60 + date.getMinutes();
      const rows = [
        {path: '[Equipment].[H1].[Name].Members'},
        {path: '[EquipmentTruck].[H1].[Name].Members'},
        {path: '[Measures].[Capacity]'},
        {path: '[Measures].[MeasuredTons]'},
        {path: '[Location].[H1].[Name].Members'},
        {path: '[Location].[H2].[Grade].Members'}
      ];

      const filters = [
        {dimension: 'ProductionStatus', hierarchy: 'H1', hierarchyLevel: 'Description', values: ['Dumping']},
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'Name', values: [truckName]},
        {dimension: 'StartTime', hierarchy: 'H1', hierarchyLevel: 'StartTimeDay', values: [dateNumber]},
        {dimension: 'StartTime', hierarchy: 'H1', hierarchyLevel: 'StartTimeMinute', values: [minutes]}
      ];

      let query = IrisUtils.buildQuery('ASPMINING.ANALYTICS.ProductionEventsCube', null, rows, null, filters);

      return IrisUtils.executeQuery(query)
        .then(response => {
          if (!response.rows.length) {
            return null;
          }
          const [truck, excavator, capacity, measuredTons, location, grade] = response.rows;

          return {
            truck: truck.caption,
            excavator: excavator.caption,
            capacity: response.data[2],
            measuredTons: response.data[3],
            location: location.caption,
            grade: grade.caption
          };
        });
    }

    function getLoadAndDumpEvents(truckName, date) {
      const dateNumber = IrisUtils.getDateNumber(date);
      const cols = [{
        path: '[Measures].[MeasuredTons]',
        children: [{
          dimension: 'ProductionEvent',
          hierarchy: 'H1',
          hierarchyLevel: 'ProductionStatusType',
          members: '&[Dumping]'
        }, {
          dimension: 'ProductionEvent',
          hierarchy: 'H1',
          hierarchyLevel: 'ProductionStatusType',
          members: '&[Loading]'
        }]
      }];

      const rows = [{
        dimension: 'EventDateTime',
        hierarchy: 'H1',
        hierarchyLevel: 'EventDateTimeMinute',
        members: 'Members'
      }];

      const filters = [
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'EquipmentName', values: [truckName]},
        {dimension: 'EventDateTime', hierarchy: 'H1', hierarchyLevel: 'EventDateTimeDay', values: [dateNumber]}
      ];

      let query = IrisUtils.buildQuery('ASPMINING.ANALYTICS.UNIFIEDEVENTSCUBE', cols, rows, null, filters);

      return IrisUtils.executeQuery(query)
        .then(data => {
          return IrisUtils.parseTreeDimensionalResponse(data);
        });
    }

    function getGanttData(trucks, date, shiftId, shiftType) {
      trucks = trucks.map(current => current.name);
      const truckFilter = trucks.map(current => `[EQUIPMENT].[H1].[NAME].&[${current}]`);

      const query = `SELECT NON EMPTY
      NONEMPTYCROSSJOIN({
        [ProductionStatus].[H1].[Description].&[TransitToLoadSite],
        [ProductionStatus].[H1].[Description].&[WaitingForLoad],
        [ProductionStatus].[H1].[Description].&[Loading],
        [ProductionStatus].[H1].[Description].&[TransitToDumpSite],
        [ProductionStatus].[H1].[Description].&[WaitingForDump],
        [ProductionStatus].[H1].[Description].&[Dumping]
      }, [Measures].[Duration]) ON 0,
      NON EMPTY HEAD(
        NONEMPTYCROSSJOIN(
          [StartTime].[H1].[StartTimeMinute].Members,
          NONEMPTYCROSSJOIN(
            [StartTime].[H1].[StartTimeDay].Members,
            [Equipment].[H1].[Name].Members
          )
        ),2000,SAMPLE
      ) ON 1 
      FROM [ASPMINING.ANALYTICS.PRODUCTIONEVENTSCUBE]
      %FILTER NONEMPTYCROSSJOIN(
        [Shift].[H1].[Id].&[${shiftId}],
        %OR({${truckFilter.join()}})
      )`;

      let shiftEnd = new Date(date.getTime());
      shiftEnd.setMinutes(0, 0, 0);
      if (shiftType === 'A') {
        shiftEnd.setHours(20);
      } else if (shiftType === 'B') {
        shiftEnd.setHours(8);
        shiftEnd.setDate(shiftEnd.getDate() + 1);
      }

      return IrisUtils.executeQuery(query)
        .then(response => {

          const result = {
            trucks: trucks,
            data: {}
          };

          const columns = response.columns;
          const rows = response.rows;
          const data = response.data;

          let rowIndex = 0;
          rows.forEach(row => {
            const minuteStr = row.caption;

            const children = row.children || [];
            children.forEach(child => {
              const dateStr = child.caption;
              const date = new Date(`${dateStr} ${minuteStr}:00`);
              const minute = date.getTime();
              child.children.forEach(truck => {
                const truckName = truck.caption;
                const truckIndex = trucks.findIndex(current => current === truckName);

                const accumulated = 0;
                columns.forEach((column, columnIndex) => {
                  const event = column.caption;
                  let value = data[rowIndex * columns.length + columnIndex];
                  if (typeof value !== 'number') {
                    return;
                  }
                  const start = minute + accumulated * 1000;
                  let finish = start + value * 1000;

                  if (finish > shiftEnd.getTime()) {
                    finish = shiftEnd.getTime();
                  }

                  result.data[event] = result.data[event] || {
                    name: event,
                    data: [],
                    dimensions: ['truckIndex', 'start', 'finish']
                  };

                  result.data[event].data.push([truckIndex, start, finish, value, truckName, date.toISOString()]);
                });
                rowIndex++;
              });
            });
          });

          for (let key in result.data) {
            result.data[key].data.sort((a, b) => a[5] > b[5] ? 1 : -1);
          }

          return result;
        })
        .catch(err => {
          return Promise.reject(err);
        });
    }
  }
})();