(() => {
  const angular = window.angular;

  Controller.$inject = [];

  angular
    .module('app')
    .component('productionRealtime', {
      templateUrl: 'realtime.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        trucks: '<'
      }
    });

  function Controller() {
    const vm = this;

    vm.$onInit = function () {
      vm.text = 'Realtime';
    };
  }
})();