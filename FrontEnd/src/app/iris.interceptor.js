(() => {
  const angular = window.angular;

  IrisInterceptor.$inject = [];

  angular
    .module('app')
    .factory('IrisInterceptor', IrisInterceptor);

  function IrisInterceptor() {
    return {
      request: function (config) {
        if (config.url.indexOf('dev.austekchile.cl') !== -1) {
          config.headers['Authorization'] = 'Basic U3VwZXJVc2VyOnN5cw==';
          config.headers['Content-Type'] = 'application/json';
        }else{
          config.headers['Authorization'] = 'Basic U3VwZXJVc2VyOnN5cw==';
          config.headers['Content-Type'] = 'application/json';
        }

        return config;
      }
    };
  }
})();