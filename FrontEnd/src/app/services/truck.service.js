(() => {
  const angular = window.angular;

  TruckService.$inject = ['$http', 'IrisUtils', 'LoadDump', 'Utils'];

  angular
    .module('app')
    .service('Truck', TruckService);

  function TruckService($http, IrisUtils, LoadDump, Utils) {

    return {
      find,
      getProduction
    };

    function find(date) {
      const dateNumber = IrisUtils.getDateNumber(date);

      const rows = [
        {dimension: 'Truck', hierarchy: 'H1', hierarchyLevel: 'Name', members: 'Members'}
      ];

      const filters = [
        {dimension: 'TIME', hierarchy: 'H1', hierarchyLevel: 'TIMEARRIVEDAY', values: [dateNumber]}
      ];

      let query = IrisUtils.buildQuery('PRODUCTIONLOADEVENTSCUBE', null, rows, null, filters);

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

    function getProduction(trucks, date) {
      const dateNumber = IrisUtils.getDateNumber(date);
      const rows = [
        {dimension: 'Time', hierarchy: 'H1', hierarchyLevel: 'TimeArriveHour', members: 'Members'}
      ];

      const filters = [
        {dimension: 'Time', hierarchy: 'H1', hierarchyLevel: 'TIMEARRIVEDAY', values: [dateNumber]}
      ];

      let query = IrisUtils.buildQuery('PRODUCTIONDUMPEVENTSCUBE', trucks, rows, ['MeasuredTons'], filters);

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