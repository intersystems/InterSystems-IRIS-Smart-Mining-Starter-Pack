(() => {
  const angular = window.angular;

  Service.$inject = ['IrisUtils', 'Utils'];

  angular
    .module('app')
    .service('Equipment', Service);

  function Service(IrisUtils, utils) {
    return {
      statusData,
      statusDetails
    };

    function statusData(from, to, categories, equipments, rowType) {
      const cube = 'ASPMINING.ANALYTICS.STATUSEVENTSLICEDCUBE';
      let rows;
      switch (rowType) {
        case 'equipment':
          rows = [{dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'Name', members: 'Members'}];
          break;
        case 'day':
          rows = [{
            dimension: 'SliceStartDate',
            hierarchy: 'H1',
            hierarchyLevel: 'SliceStartDateDay',
            members: 'Members'
          }];
          break;
        case 'minute':
        default:
          rows = [{
            dimension: 'SliceStartDate',
            hierarchy: 'H1',
            hierarchyLevel: 'SliceStartDateMinute',
            members: 'Members'
          }];
      }

      const fromNumber = IrisUtils.getDateNumber(from);
      const toNumber = IrisUtils.getDateNumber(to);

      const columns = [];
      ['Operative', 'Delay', 'Standby', 'Downtime'].forEach(current => {
        columns.push({
          dimension: 'StatusType',
          hierarchy: 'H1',
          hierarchyLevel: 'StatusType',
          members: `&[${current}]`
        });
      });

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

      if (equipments && equipments.length) {
        filters.push({
          dimension: 'EQUIPMENT',
          hierarchy: 'H1',
          hierarchyLevel: 'Name',
          values: Array.isArray(equipments)
            ? equipments.map(current => current.name)
            : [equipments.name]
        });
      } else {
        filters.push({
          dimension: 'EQUIPMENT',
          hierarchy: 'H1',
          hierarchyLevel: 'CATEGORY',
          values: Array.isArray(categories)
            ? categories.map(current => current.name)
            : [categories.name]
        });
      }

      let query = IrisUtils.buildQuery(cube, columns, rows, ['PartialDuration'], filters);
      return IrisUtils.executeQuery(query)
        .then(data => {
          return IrisUtils.parseTwoDimensionalResponse(data, true);
        });
    }

    function statusDetails(from, to, categories, equipments, status) {
      const cube = 'ASPMINING.ANALYTICS.STATUSEVENTSLICEDCUBE';

      const fromNumber = IrisUtils.getDateNumber(from);
      const toNumber = IrisUtils.getDateNumber(to);

      const columns = [{
        dimension: 'Reason',
        hierarchy: 'H1',
        hierarchyLevel: 'Description',
        members: `Members`
      }];
      const rows = [
        {dimension: 'SliceStartDate', hierarchy: 'H1', hierarchyLevel: 'SliceStartDateMinute', members: 'Members'}
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
      }, {
        dimension: 'STATUSTYPE',
        hierarchy: 'H1',
        hierarchyLevel: 'STATUSTYPE',
        values: [status]
      }];

      if (equipments && equipments.length) {
        filters.push({
          dimension: 'EQUIPMENT',
          hierarchy: 'H1',
          hierarchyLevel: 'Name',
          values: Array.isArray(equipments)
            ? equipments.map(current => current.name)
            : [equipments.name]
        });
      } else {
        filters.push({
          dimension: 'EQUIPMENT',
          hierarchy: 'H1',
          hierarchyLevel: 'CATEGORY',
          values: Array.isArray(categories)
            ? categories.map(current => current.name)
            : [categories.name]
        });
      }

      let query = IrisUtils.buildQuery(cube, columns, rows, ['PartialDuration'], filters);

      return IrisUtils.executeQuery(query)
        .then(data => {
          return IrisUtils.parseTwoDimensionalResponse(data);
        });
    }
  }
})();