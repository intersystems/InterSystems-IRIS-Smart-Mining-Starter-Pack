(() => {
  const angular = window.angular;
  const DEFAULT_CUBE = 'ASPMINING.ANALYTICS.STATUSEVENTSLICEDCUBE';

  Service.$inject = ['IrisUtils', 'Utils'];

  angular
    .module('app')
    .service('EquipmentCategory', Service);

  function Service(IrisUtils, utils) {
    return {
      find
    };

    function find(from, to, cube) {
      cube = cube || DEFAULT_CUBE;

      const fromNumber = IrisUtils.getDateNumber(from);
      const toNumber = IrisUtils.getDateNumber(to);

      const rows = [
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'Category', members: 'Members'}
      ];

      let dates = fromNumber;
      if (fromNumber !== toNumber) {
        dates = [fromNumber, toNumber];
      }

      const filters = [{
        dimension: 'SLICESTARTDATE',
        hierarchy: 'H1',
        hierarchyLevel: 'SLICESTARTDATEDAY',
        values: [dates]
      }];

      let query = IrisUtils.buildQuery(cube, null, rows, null, filters);

      return IrisUtils.executeQuery(query)
        .then(data => {
          return data.Cols[1].tuples.map(current => {
            return {name: current.caption, path: current.path, id: current.valueID};
          });
        });
    }
  }
})();