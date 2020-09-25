(() => {
  const angular = window.angular;

  Service.$inject = ['IrisUtils'];

  angular
    .module('app')
    .service('ProductionEventsShift', Service);

  function Service(IrisUtils) {
    return {
      findByDate
    };

    function findByDate(date) {
      const dateNumber = IrisUtils.getDateNumber(date);
      const query = `
        SELECT 
          NON EMPTY [Shift].[H2].[Type].Members ON 0,
          NON EMPTY [Shift].[H1].[Id].Members ON 1 
        FROM [ASPMINING.ANALYTICS.PRODUCTIONEVENTSCUBE] 
        %FILTER [ShiftDateTime].[H1].[DateTimeDay].&[${dateNumber}]`;

      return IrisUtils.executeQuery(query)
        .then(result => {
          const shifts = [];
          if (result.columns && result.rows) {
            result.columns.forEach((current, index) => {
              shifts.push({type: current.caption, id: result.rows[index].caption});
            });
          }
          return shifts;
        });
    }
  }
})();