(() => {
  'use strict';

  const angular = window.angular;

  AppRouter.$inject = ['$urlRouterProvider', '$stateProvider'];

  angular
    .module('app')
    .config(AppRouter);

  function AppRouter($urlRouterProvider, $stateProvider) {
    $urlRouterProvider
      .otherwise('');

    $stateProvider
      .state('home', {
        url: '/',
        component: 'home'
      })
      .state('mineOperation', {
        url: '/mine-operation',
        component: 'mineOperation',
        redirectTo: 'mineOperation.production'
      })
      .state('mineOperation.oee', {
        url: '/oee',
        component: 'moOee',
        redirectTo: 'mineOperation.oee.overview'
      })
      .state('mineOperation.oee.overview', {
        url: '/overview',
        component: 'oeeOverview'
      })
      .state('mineOperation.oee.timePerformance', {
        url: '/time-performance',
        component: 'oeeTimePerformance'
      })
      .state('mineOperation.oee.utilization', {
        url: '/utilization',
        component: 'oeeUtilization'
      })
      .state('mineOperation.oee.capacityPerformance', {
        url: '/capacity-performance',
        component: 'oeeCapacityPerformance'
      })
      .state('mineOperation.production', {
        url: '/production',
        component: 'moProduction',
        redirectTo: 'mineOperation.production.realtime'
      })
      .state('mineOperation.production.realtime', {
        url: '/realtime',
        component: 'productionRealtime'
      })
      .state('mineOperation.production.ranking', {
        url: '/ranking',
        component: 'productionRanking'
      })
      .state('mineOperation.production.compliance', {
        url: '/compliance',
        component: 'productionCompliance'
      })
      .state('mineOperation.miningPlan', {
        url: '/mining-plan',
        component: 'moMiningPlan',
        redirectTo: 'mineOperation.miningPlan.index'
      })
      .state('mineOperation.miningPlan.index', {
        url: '/',
        component: 'miningPlanIndex'
      })
      .state('mineOperation.miningPlan.tracing', {
        url: '/tracing',
        component: 'miningPlanTracing'
      });

  }
})();
