;(function () {
  'use strict';

  const angular = window.angular;

  AppConfig.$inject = ['$locationProvider', '$httpProvider'];

  angular
    .module('app')
    .config(AppConfig);

  function AppConfig($locationProvider, $httpProvider) {
    $locationProvider.html5Mode(true).hashPrefix('#');
    $httpProvider.interceptors.push('IrisInterceptor');
  }
})();
