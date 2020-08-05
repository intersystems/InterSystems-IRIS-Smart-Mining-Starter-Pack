;(() => {
  const angular = window.angular;

  Controller.$inject = [];

  angular
    .module('app')
    .component('equipmentRankingDetails', {
      templateUrl: 'equipment-ranking-details.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        from: '<',
        to: '<',
        categories: '<'
      }
    });

  function Controller() {
    const vm = this;

    vm.$onInit = function () {
      vm.status = ['Operative', 'Delay', 'Standby', 'Downtime'];
      vm.onSelectStatus = onSelectStatus;
      vm.selectedStatus = null;
    };

    vm.$onChanges = function () {
      vm.selectedStatus = null;
    };

    vm.$onDestroy = function () {
    };

    function onSelectStatus() {
    }
  }
})();