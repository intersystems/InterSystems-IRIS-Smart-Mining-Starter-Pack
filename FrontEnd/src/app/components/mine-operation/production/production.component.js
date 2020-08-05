(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', '$compile', '$transitions', '$state'];

  angular
    .module('app')
    .component('moProduction', {
      templateUrl: 'production.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller($root, $timeout, $element, $compile, $transitions, $state) {
    const vm = this;

    vm.$onInit = function () {
      vm.filterTarget = $element.find('.filters-target');
      vm.offSuccess = $transitions.onSuccess({}, transition => {
        displayFilters();
      });

      displayFilters();
    };

    vm.$onDestroy = function () {
      vm.offSuccess();
      if (vm.filterScope) {
        vm.filterScope.$destroy();
      }
    };

    function displayFilters() {
      const currentState = $state.current;

      const filtersMap = {
        'mineOperation.production.ranking': 'equipment-rank-filter'
      };

      const tagName = filtersMap[currentState.name] || 'prod-default-filter';
      if (vm.currentTagName === tagName) {
        return;
      }

      vm.currentTagName = tagName;

      if (vm.filterScope) {
        vm.filterScope.$destroy();
        vm.filterTarget.empty();
      }

      $timeout(() => {
        vm.filterScope = $root.$new(true);
        vm.filterTarget.append($compile(`<${tagName}></${tagName}>`)(vm.filterScope));
      }, 200);
    }
  }
})();