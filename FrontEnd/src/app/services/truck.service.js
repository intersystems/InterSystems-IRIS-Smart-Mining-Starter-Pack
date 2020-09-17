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
      getProductionByDay,
      getTimePerformanceByDay
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
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'Name', members: 'Members'}
      ];

      const filters = [
        {dimension: 'StartTime', hierarchy: 'H1', hierarchyLevel: 'StartTimeDay', values: [dateNumber]},
        {dimension: 'Equipment', hierarchy: 'H2', hierarchyLevel: 'Category', values: ['Camion']}
      ];

      let query = IrisUtils.buildQuery('ASPMining.Analytics.ProductionEventsCube', null, rows, null, filters);

      console.log(query);
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
          hierarchy: 'H1',
          hierarchyLevel: 'EquipmentName',
          values: trucks.map(current => current.name)
        });
      }
      let query = IrisUtils.buildQuery('ASPMINING.ANALYTICS.UNIFIEDEVENTSCUBE', cols, rows, null, filters);
      return IrisUtils.executeQuery(query)
        .then(result => {
          return IrisUtils.parseTwoDimensionalResponse(result);
        })
        .catch(err => {
          console.log(err);
        });
    }

    function getTimePerformanceByDay(date, trucks) {
      const dateNumber = IrisUtils.getDateNumber(date);
      const cols = [
        {path: '[Measures].[MeasuredTons]'},
        {path: '[MEMBERDIMENSION].[TimePerformance]'}
      ];
      const rows = [
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'EquipmentName', members: 'Members'}
      ];

      const filters = [
        {dimension: 'EventDateTime', hierarchy: 'H1', hierarchyLevel: 'EventDateTimeDay', values: [dateNumber]},
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'EquipmentCategory', values: ['Camion']}
      ];

      if (trucks) {
        filters.push({
          dimension: 'Equipment',
          hierarchy: 'H1',
          hierarchyLevel: 'EquipmentName',
          values: trucks.map(current => current.name)
        });
      }
      let query = IrisUtils.buildQuery('ASPMINING.ANALYTICS.UNIFIEDEVENTSCUBE', cols, rows, null, filters);
      return IrisUtils.executeQuery(query)
        .then(result => {
          return IrisUtils.parseTwoDimensionalResponse(result);
        })
        .catch(err => {
          console.log(err);
        });
    }
  }
})();