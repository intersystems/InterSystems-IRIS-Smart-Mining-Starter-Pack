;(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$element', 'Equipment'];

  angular
    .module('app')
    .component('equipmentRanking', {
      templateUrl: 'equipment-ranking-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller($root, $element, Equipment) {
    const vm = this;

    vm.$onInit = function () {
      const container = $element.find('.chart');
      vm.container = container[0];

      vm.category = null;
      vm.filters = {};
      vm.loading = false;
      vm.offFilters = $root.$on('filter:update', (e, filters) => {
        vm.filters = angular.copy(filters);
        vm.from = vm.filters.from;
        vm.to = vm.filters.to;
        vm.category = vm.filters.category;
        vm.categories = vm.category ? [vm.category] : null;
      });
    };

    vm.$onDestroy = function () {
      vm.offFilters();
    };
  }
})();