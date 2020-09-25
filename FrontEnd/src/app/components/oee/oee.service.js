(() => {
  const angular = window.angular;

  Service.$inject = ['IrisUtils', 'Utils', '$rootScope', '$q'];

  angular
    .module('app')
    .service('OEE', Service);

  const cube = 'ASPMining.Analytics.UnifiedEventsCube';

  function Service(IrisUtils, Utils, $root, $q) {
    const cache = {
      days: {},
      hours: {},
      minutes: {}
    };

    return {
      categories,
      equipments,
      listenFilters,
      loadDataAsDays,
      loadDataAsHours,
      loadDataAsMinutes,
      loadDataByEquipment,
      capacityPerformance
    };

    function listenFilters(type) {
      let vars = {};
      vars.offFilters = $root.$on('filter:update', (e, filters) => {
        filters = angular.copy(filters);
        vars.from = filters.from;
        vars.to = filters.to;
        vars.categories = filters.categories;
        vars.equipments = filters.equipments;

        if (!vars.categories || !vars.categories.length) {
          return {};
        }

        vars.loading = true;
        loadDataAsDays(vars.from, vars.to, type, vars.categories, vars.equipments)
          .then(result => {
            vars.loading = false;
            vars.data = result;
          })
          .catch(err => {
            vars.loading = false;
            console.log(err);
          });
      });
      return vars;
    }

    function categories(from, to) {
      const fromNumber = IrisUtils.getDateNumber(from);
      const toNumber = IrisUtils.getDateNumber(to);

      const rows = [
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'EQUIPMENTCATEGORY', members: 'Members'}
      ];

      let dates = fromNumber;
      if (fromNumber !== toNumber) {
        dates = [fromNumber, toNumber];
      }

      const filters = [{
        dimension: 'EventDateTime',
        hierarchy: 'H1',
        hierarchyLevel: 'EventDateTimeDay',
        values: [dates]
      }];

      let query = IrisUtils.buildQuery(cube, null, rows, null, filters);

      return IrisUtils.executeQuery(query)
        .then(data => {
          return data.rows.map(current => {
            return {name: current.caption, path: current.path, id: current.valueID};
          });
        });
    }

    function equipments(from, to, category) {
      const fromNumber = IrisUtils.getDateNumber(from);
      const toNumber = IrisUtils.getDateNumber(to);

      const rows = [
        {dimension: 'Equipment', hierarchy: 'H1', hierarchyLevel: 'EQUIPMENTNAME', members: 'Members'}
      ];

      let dates = fromNumber;
      if (fromNumber !== toNumber) {
        dates = [fromNumber, toNumber];
      }

      const categories = Array.isArray(category) ? category.map(current => current.name) : [category.name];

      const filters = [{
        dimension: 'EventDateTime',
        hierarchy: 'H1',
        hierarchyLevel: 'EventDateTimeDay',
        values: [dates]
      }, {
        dimension: 'Equipment',
        hierarchy: 'H1',
        hierarchyLevel: 'EQUIPMENTCATEGORY',
        values: categories
      }];

      let query = IrisUtils.buildQuery(cube, null, rows, null, filters);

      return IrisUtils.executeQuery(query)
        .then(data => {
          return data.rows.map(current => {
            return {name: current.caption, path: current.path, id: current.valueID};
          });
        });
    }

    function loadDataAsDays(from, to, type, categories, equipments) {
      return loadData('EventDateTimeDay', from, to, type, categories, equipments);
    }

    function loadDataAsHours(from, to, type, categories, equipments) {
      return loadData('EventDateTimeHour', from, from, type, categories, equipments);
    }

    function loadDataAsMinutes(from, hour, type, categories, equipments) {
      from = new Date(from.getTime());
      from.setHours(hour);
      return loadData('EventDateTimeMinute', from, from, type, categories, equipments);
    }

    function loadData(timeInterval, from, to, type, categories, equipments) {
      const fromNumber = IrisUtils.getDateNumber(from);
      const toNumber = IrisUtils.getDateNumber(to);

      const columns = [{
        path: `[MEMBERDIMENSION].allMembers`
      }];

      const rows = [
        {dimension: 'EventDateTime', hierarchy: 'H1', hierarchyLevel: timeInterval, members: 'Members'}
      ];

      let dates = fromNumber;
      if (fromNumber !== toNumber) {
        dates = [fromNumber, toNumber];
      }

      const filters = [[]];

      if (equipments && equipments.length) {
        filters[0].push({
          dimension: 'EQUIPMENT',
          hierarchy: 'H1',
          hierarchyLevel: 'EQUIPMENTNAME',
          values: equipments.map(current => current.name)
        });
      } else {
        filters[0].push({
          dimension: 'EQUIPMENT',
          hierarchy: 'H1',
          hierarchyLevel: 'EQUIPMENTCATEGORY',
          values: categories.map(current => current.name)
        });
      }

      filters[0].push({
        dimension: 'EventDateTime',
        hierarchy: 'H1',
        hierarchyLevel: 'EventDateTimeDay',
        values: [dates]
      });

      if (timeInterval === 'EventDateTimeMinute') {
        filters[0].push({
          dimension: 'EventDateTime',
          hierarchy: 'H1',
          hierarchyLevel: 'EventDateTimeHour',
          values: [from.getHours()]
        });
      }

      let query = IrisUtils.buildQuery(cube, columns, rows, null, filters);
      cache[timeInterval] = cache[timeInterval] || {};
      if (cache[timeInterval].data && cache[timeInterval].query === query) {
        if (type) {
          return $q.resolve(cache[timeInterval].data.filter(current => current.category === type));
        }
        return $q.resolve(cache[timeInterval].data);
      }

      return IrisUtils.executeQuery(query)
        .then(result => {
          cache[timeInterval].query = query;
          const data = IrisUtils.parseTwoDimensionalResponse(result);
          cache[timeInterval].data = data;
          if (type) {
            return data.filter(current => current.category === type);
          }
          return data;
        });
    }

    function loadDataByEquipment(from, to, type, categories, equipments) {
      const fromNumber = IrisUtils.getDateNumber(from);
      const toNumber = IrisUtils.getDateNumber(to);

      const columns = [{path: `[MEMBERDIMENSION].allMembers`}];

      const rows = [{path: '[Equipment].[H1].[EquipmentName].Members'}];

      let dates = fromNumber;
      if (fromNumber !== toNumber) {
        dates = [fromNumber, toNumber];
      }

      const filters = [];

      if (equipments && equipments.length) {
        filters.push({
          dimension: 'EQUIPMENT',
          hierarchy: 'H1',
          hierarchyLevel: 'EQUIPMENTNAME',
          values: equipments.map(current => current.name)
        });
      } else {
        filters.push({
          dimension: 'EQUIPMENT',
          hierarchy: 'H1',
          hierarchyLevel: 'EQUIPMENTCATEGORY',
          values: categories.map(current => current.name)
        });
      }

      filters.push({
        dimension: 'EventDateTime',
        hierarchy: 'H1',
        hierarchyLevel: 'EventDateTimeDay',
        values: [dates]
      });

      let query = IrisUtils.buildQuery(cube, columns, rows, null, filters);
      return IrisUtils.executeQuery(query)
        .then(result => {
          const data = IrisUtils.parseTwoDimensionalResponse(result, true);
          if (type) {
            return data.filter(current => current.category === type);
          }
          return data;
        });
    }

    function timePerformance(from, to, timeInterval, trucks) {
      const fromNumber = IrisUtils.getDateNumber(from);
      const toNumber = IrisUtils.getDateNumber(to);
      let dates = fromNumber;
      if (fromNumber !== toNumber) {
        dates = [fromNumber, toNumber];
      }

      const columns = [
        {path: `[Measures].[MeasuredTons]`},
        {path: `[MEMBERDIMENSION].[TimePerformance]`}
      ];
      const rows = [{path: `[EventDateTime].[H1].[${timeInterval}].Members`}];

      const filters = [];
      if (trucks && trucks.length) {
        filters.push({
          dimension: 'EQUIPMENT',
          hierarchy: 'H1',
          hierarchyLevel: 'EQUIPMENTNAME',
          values: trucks.map(current => current.name)
        });
      } else {
        filters.push({
          path: '[EQUIPMENT].[H1].[EQUIPMENTCATEGORY].&[Camion]'
        });
      }

      filters.push({
        dimension: 'EventDateTime',
        hierarchy: 'H1',
        hierarchyLevel: 'EventDateTimeDay',
        values: [dates]
      }/*, {
        path: '[ProductionEvent].[H1].[ProductionStatusType].&[Dumping]'
      }*/);

      if (timeInterval === 'EventDateTimeMinute') {
        filters.push({
          dimension: 'EventDateTime',
          hierarchy: 'H1',
          hierarchyLevel: 'EventDateTimeHour',
          values: [from.getHours()]
        });
      }

      let query = IrisUtils.buildQuery(cube, columns, rows, null, filters);

      return IrisUtils.executeQuery(query)
        .then(result => {
          return IrisUtils.parseTwoDimensionalResponse(result);
        })
        .catch(response => {
          return Promise.reject(Utils.getHTTPError(response));
        });
    }

    function capacityPerformance(from, to, timeInterval, trucks) {
      const fromNumber = IrisUtils.getDateNumber(from);
      const toNumber = IrisUtils.getDateNumber(to);
      let dates = fromNumber;
      if (fromNumber !== toNumber) {
        dates = [fromNumber, toNumber];
      }

      const columns = [
        {path: `[Measures].[MeasuredTons]`},
        {path: `[MEMBERDIMENSION].[CapacityPerformance]`}
      ];
      const rows = [{path: `[EventDateTime].[H1].[${timeInterval}].Members`}];

      const filters = [];
      if (trucks && trucks.length) {
        filters.push({
          dimension: 'EQUIPMENT',
          hierarchy: 'H1',
          hierarchyLevel: 'EQUIPMENTNAME',
          values: trucks.map(current => current.name)
        });
      } else {
        filters.push({
          path: '[EQUIPMENT].[H1].[EQUIPMENTCATEGORY].&[Camion]'
        });
      }

      filters.push({
        dimension: 'EventDateTime',
        hierarchy: 'H1',
        hierarchyLevel: 'EventDateTimeDay',
        values: [dates]
      }, {
        path: '[ProductionEvent].[H1].[ProductionStatusType].&[Dumping]'
      });

      if (timeInterval === 'EventDateTimeMinute') {
        filters.push({
          dimension: 'EventDateTime',
          hierarchy: 'H1',
          hierarchyLevel: 'EventDateTimeHour',
          values: [from.getHours()]
        });
      }

      let query = IrisUtils.buildQuery(cube, columns, rows, null, filters);
      cache[timeInterval] = cache[timeInterval] || {};

      return IrisUtils.executeQuery(query)
        .then(result => {
          return IrisUtils.parseTwoDimensionalResponse(result);
        })
        .catch(response => {
          return Promise.reject(Utils.getHTTPError(response));
        });
    }
  }
})();