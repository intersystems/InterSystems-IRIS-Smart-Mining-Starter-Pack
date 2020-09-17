window.IRIS_URL = 'http://gw.xompass.com:52773/MDX2JSON/MDX?Namespace=APPINT';
;(() => {
  'use strict';

  window.angular
    .module('app', [
      'ngSanitize',
      'angular-storage',
      'ui.router',
      'ui.select',
      'ui.bootstrap',
      'ui.bootstrap.datetimepicker',
      'pascalprecht.translate'
    ]);
})();
