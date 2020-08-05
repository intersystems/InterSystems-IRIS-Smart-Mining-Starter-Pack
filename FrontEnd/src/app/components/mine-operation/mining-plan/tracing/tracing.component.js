(() => {
  const angular = window.angular;

  angular
    .module('app')
    .component('miningPlanTracing', {
      templateUrl: 'tracing.template.html'
    });
})();