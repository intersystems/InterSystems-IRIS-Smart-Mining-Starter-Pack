(() => {
  const angular = window.angular;

  Controller.$inject = [];

  angular
    .module('app')
    .component('oeeDetails', {
      templateUrl: 'oee-details.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller() {
    const vm = this;

    vm.$onInit = function () {
    };

    vm.$onDestroy = function () {
    };
  }
})();