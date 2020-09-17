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
          if (!response.Cols || !response.Cols.length) {
            return null;
          }
          const [truck, excavator, capacity, measuredTons, location, grade] = response.Cols[1].tuples;

          return {
            truck: truck.caption,
            excavator: excavator.caption,
            capacity: response.Data[2],
            measuredTons: response.Data[3],
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

    function getGanttData(trucks, date) {
      const names = {
        load: 'Carga',
        transitToDump: 'En transito a Descarga',
        dump: 'Descarga',
        transitToLoad: 'En transito a Carga'
      };

      const rawData = {
        dump: {name: 'Descarga', data: []},
        load: {name: 'Carga', data: []}
      };

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
          [Equipment].[H1].[Name].Members
        ),2000,SAMPLE
      ) ON 1 
      FROM [ASPMINING.ANALYTICS.PRODUCTIONEVENTSCUBE]
      %FILTER NONEMPTYCROSSJOIN(
        [StartTime].[H1].[StartTimeDay].&[${IrisUtils.getDateNumber(date)}],
        %OR({${truckFilter.join()}})
      )`;

      return IrisUtils.executeQuery(query)
        .then(response => {
          const result = {
            trucks: trucks,
            data: {}
          };
          if (!response.Cols || !response.Cols.length) {
            return result;
          }

          const columns = response.Cols[0].tuples;
          const rows = response.Cols[1].tuples;
          const data = response.Data;

          const dateStr = $filter('date')(date, 'yyyy-MM-dd');

          let rowIndex = 0;
          rows.forEach(row => {
            const minute = new Date(`${dateStr} ${row.caption}:00`).getTime();
            const children = row.children || [];
            children.forEach(truck => {
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
                const finish = start + value * 1000;

                result.data[event] = result.data[event] || {
                  name: event,
                  data: [],
                  dimensions: ['truckIndex', 'start', 'finish']
                };

                result.data[event].data.push([truckIndex, start, finish, value]);
              });
              rowIndex++;
            });
          });
          return result;
        })
        .catch(err => {
          return Promise.reject(err);
        });
    }
  }
})();