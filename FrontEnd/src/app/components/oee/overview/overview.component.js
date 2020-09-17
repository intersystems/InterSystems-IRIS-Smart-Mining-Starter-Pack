(() => {
  const angular = window.angular;

  Controller.$inject = ['OEE'];

  angular
    .module('app')
    .component('oeeOverview', {
      templateUrl: 'overview.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller(OEE) {
    const vm = this;

    vm.$onInit = function () {
      vm.filters = OEE.listenFilters();
    };

    vm.$onDestroy = function () {
      vm.filters.offFilters();
    };
  }
})();