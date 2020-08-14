(() => {
  const angular = window.angular;

  Controller.$inject = ['OEE'];

  angular
    .module('app')
    .component('oeeCapacityPerformance', {
      templateUrl: 'capacity-performance.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller(OEE) {
    const vm = this;

    vm.$onInit = function () {

    };

    vm.$onDestroy = function () {

    };
  }
})();