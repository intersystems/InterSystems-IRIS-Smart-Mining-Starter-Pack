(() => {
  'use strict';

  const angular = window.angular;

  AppRouter.$inject = ['$urlRouterProvider', '$stateProvider'];

  angular
    .module('app')
    .config(AppRouter);

  function AppRouter($urlRouterProvider, $stateProvider) {
    $urlRouterProvider
      .otherwise('/oee');

    $stateProvider
      .state('oee', {
        url: '/oee',
        component: 'oee',
        redirectTo: 'oee.overview'
      })
      .state('oee.overview', {
        url: '/overview',
        component: 'oeeOverview'
      })
      .state('oee.details', {
        url: '/',
        component: 'oeeDetails'
      })
      .state('oee.timePerformance', {
        url: '/time-performance',
        component: 'oeeTimePerformance'
      })
      .state('oee.utilization', {
        url: '/utilization',
        component: 'oeeUtilization'
      })
      .state('oee.capacityPerformance', {
        url: '/capacity-performance',
        component: 'oeeCapacityPerformance'
      })
      .state('production', {
        url: '/production',
        component: 'production'
      })
      .state('fleetInformation', {
        url: '/fleet',
        component: 'fleetInformation'
      });
  }
})();
