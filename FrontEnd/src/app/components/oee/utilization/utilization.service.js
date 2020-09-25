(() => {
  const angular = window.angular;

  Utilization.$inject = ['$http', 'IrisUtils', 'Utils'];

  angular
    .module('app')
    .service('Utilization', Utilization);

  function Utilization($http, IrisUtils, Utils) {
    return {
      byDay
    };

    function byDay(from, to, categories) {
      const cube = 'ASPMINING.ANALYTICS.STATUSEVENTSLICEDCUBE';
      const fromNumber = IrisUtils.getDateNumber(from);
      const toNumber = IrisUtils.getDateNumber(to);

      const columns = [{
        dimension: 'ShiftInfo',
        hierarchy: 'H2',
        hierarchyLevel: 'ShiftType',
        members: `Members`,
        children: [{
          dimension: 'StatusType',
          hierarchy: 'H1',
          hierarchyLevel: 'StatusType',
          members: `Members`
        }]
      }];

      const rows = [
        {dimension: 'SliceStartDate', hierarchy: 'H1', hierarchyLevel: 'SliceStartDateDay', members: 'Members'}
      ];

      let dates = fromNumber;
      if (fromNumber !== toNumber) {
        dates = [fromNumber, toNumber];
      }

      const filters = [{
        dimension: 'EQUIPMENT',
        hierarchy: 'H1',
        hierarchyLevel: 'CATEGORY',
        values: categories.map(current => current.name)
      }, {
        dimension: 'SLICESTARTDATE',
        hierarchy: 'H1',
        hierarchyLevel: 'SliceStartDateDay',
        values: [dates]
      }];

      let query = IrisUtils.buildQuery(cube, columns, rows, 'PartialDuration', filters);

      return $http
        .post(window.IRIS_URL, {'MDX': query})
        .then(response => {
          return IrisUtils.parseTreeDimensionalResponse(response.data);
        })
        .catch(response => {
          return Promise.reject(Utils.getHTTPError(response));
        });
    }
  }
})();