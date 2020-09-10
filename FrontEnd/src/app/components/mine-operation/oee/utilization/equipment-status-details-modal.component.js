;(() => {
  const angular = window.angular;

  Controller.$inject = ['$uibModal'];

  angular
    .module('app')
    .component('equipmentStatusDetailsModal', {
      templateUrl: 'equipment-status-details-modal.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        resolve: '<',
        modalInstance: '<'
      }
    });

  function Controller($uibModal) {
    const vm = this;

    vm.$onInit = function () {
      vm.date = vm.resolve.date;
      vm.categories = vm.resolve.categories;
    };
  }
})();