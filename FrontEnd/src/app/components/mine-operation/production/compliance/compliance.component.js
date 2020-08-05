(() => {
  const angular = window.angular;

  angular
    .module('app')
    .component('productionCompliance', {
      templateUrl: 'compliance.template.html'
    });
})();