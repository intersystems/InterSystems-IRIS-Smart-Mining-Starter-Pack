;(() => {
  const angular = window.angular;

  Controller.$inject = ['$translate'];

  angular
    .module('app')
    .component('equipmentStatusDetails', {
      templateUrl: 'equipment-status-details.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        from: '<',
        to: '<',
        categories: '<',
        hideTitle: '<'
      }
    });

  function Controller($translate) {
    const vm = this;

    vm.$onInit = function () {
      vm.status = [
        'Operative', 
        'Delay', 
        'Standby', 
        'Downtime'
      ];
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