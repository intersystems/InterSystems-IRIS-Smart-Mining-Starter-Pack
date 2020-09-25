(() => {
  const angular = window.angular;

  Service.$inject = ['IrisUtils'];

  angular
    .module('app')
    .service('ProductionEventsEquipment', Service);

  function Service(IrisUtils) {
    return {
      findByShift
    };

    function findByShift(shiftId) {
      const query = `
        SELECT 
          NON EMPTY [Equipment].[H1].[Name].Members ON 1 
        FROM 
          [ASPMINING.ANALYTICS.PRODUCTIONEVENTSCUBE] 
        %FILTER 
          [Shift].[H1].[Id].&[${shiftId}]`;

      return IrisUtils.executeQuery(query)
        .then(response => {
          const equipments = [];
          const columns = response.rows;
          if (columns) {
            columns.forEach(current => {
              equipments.push({name: current.caption});
            });
          }
          return equipments;
        });
    }
  }
})();