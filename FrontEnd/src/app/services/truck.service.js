(() => {
  const angular = window.angular;

  TruckService.$inject = ['$http', 'IrisUtils', 'LoadDump', 'Utils'];

  angular
    .module('app')
    .service('Truck', TruckService);

  function TruckService($http, IrisUtils, LoadDump, Utils) {

    return {
      find,
      getCapacity,
      getProductionByHourOfDay,
      getProductionByDay
    };

    function getCapacity(truckName) {
      const rows = [
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'EquipmentName', members: 'Members'}
      ];
      const filters = [
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'EquipmentName', values: [truckName]}
      ];

      let query = IrisUtils.buildQuery('ASPMining.Analytics.UnifiedEventsCube', null, rows, ['CapacityMax'], filters);
      return IrisUtils.executeQuery(query)
        .then(response => {
          response = IrisUtils.parseTwoDimensionalResponse(response)[0];
          return response.data[0][1];
        });
    }

    function find(date) {
      const dateNumber = IrisUtils.getDateNumber(date);

      const rows = [
        {dimension: 'Truck', hierarchy: 'H1', hierarchyLevel: 'Name', members: 'Members'}
      ];

      const filters = [
        {dimension: 'TIME', hierarchy: 'H1', hierarchyLevel: 'TIMEARRIVEDAY', values: [dateNumber]}
      ];

      let query = IrisUtils.buildQuery('ASPMining.Analytics.ProductionLoadEventsCube', null, rows, null, filters);

      return IrisUtils.executeQuery(query)
        .then(data => {
          if (!data.Cols || !data.Cols[1]) {
            return [];
          }

          return data.Cols[1].tuples.map(current => {
            return {name: current.caption, path: current.path, id: current.valueID};
          });
        });
    }

    function getProductionByDay(date, trucks) {
      const dateNumber = IrisUtils.getDateNumber(date);
      const cols = [
        {path: '[Measures].[MeasuredTons]'},
        {path: '[MEMBERDIMENSION].[CapacityPerformance]'}
      ];
      const rows = [
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'EquipmentName', members: 'Members'}
      ];

      const filters = [
        {dimension: 'EventDateTime', hierarchy: 'H1', hierarchyLevel: 'EventDateTimeDay', values: [dateNumber]},
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'EquipmentCategory', values: ['Camion']},
        {dimension: 'ProductionEvent', hierarchy: 'H1', hierarchyLevel: 'ProductionStatusType', values: ['Dumping']}
      ];

      if (trucks) {
        filters.push({
          dimension: 'Equipment',
          hierarchy: 'H2',
          hierarchyLevel: 'EquipmentName',
          values: trucks.map(current => current.name)
        });
      }

      let query = IrisUtils.buildQuery('ASPMINING.ANALYTICS.UNIFIEDEVENTSCUBE', cols, rows, null, filters);

      console.log(query);
      return IrisUtils.executeQuery(query)
        .then(result => {
          return IrisUtils.parseTwoDimensionalResponse(result);
        })
        .catch(err => {
          console.log(err);
        });
    }

    function getProductionByHourOfDay(date, trucks) {
      const dateNumber = IrisUtils.getDateNumber(date);
      const rows = [
        {dimension: 'Time', hierarchy: 'H1', hierarchyLevel: 'TimeArriveHour', members: 'Members'}
      ];

      const filters = [
        {dimension: 'Time', hierarchy: 'H1', hierarchyLevel: 'TIMEARRIVEDAY', values: [dateNumber]}
      ];

      let query = IrisUtils.buildQuery('ASPMining.Analytics.ProductionDumpEventsCube', trucks, rows, ['MeasuredTons'], filters);

      return IrisUtils.executeQuery(query)
        .then(responseData => {
          const _data = responseData;

          const result = [];
          const columns = _data.Cols[0].tuples;
          const rows = _data.Cols[1].tuples;
          const data = _data.Data;

          for (let colIndex = 0; colIndex < columns.length; colIndex++) {
            const truck = columns[colIndex];
            const current = {equipmentName: truck.caption, categories: [], values: []};
            result.push(current);
            for (let rowIndex = 0; rowIndex < rows.length; rowIndex++) {
              const timeInterval = rows[rowIndex].caption;
              let value = data[rowIndex * columns.length + colIndex];
              value = isNaN(parseFloat(value)) ? 0 : parseFloat(value);

              current.categories.push(timeInterval);
              current.values.push(value);
            }
          }
          return result;
        });
    }
  }
})();