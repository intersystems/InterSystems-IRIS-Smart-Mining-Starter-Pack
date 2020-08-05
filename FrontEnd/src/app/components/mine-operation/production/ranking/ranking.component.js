(() => {
  const angular = window.angular;

  angular
    .module('app')
    .component('productionRanking', {
      templateUrl: 'ranking.template.html'
    });

})();