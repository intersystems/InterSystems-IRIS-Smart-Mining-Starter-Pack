(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', 'EquipmentCategory', '$transitions'];

  angular
    .module('app')
    .component('equipmentRankFilter', {
      templateUrl: 'equip-rank-filter.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller($root, EquipmentCategory, $transitions) {
    const vm = this;

    vm.$onInit = function () {
      vm.applyFilters = applyFilters;

      vm.dates = {
        from: {value: new Date('2018/01/01'), open: false},
        to: {value: new Date('2018/01/01'), open: false},
        options: {showWeeks: false, showMeridian: false},
        onClose: function (args) {
          loadCategories();
        }
      };

      loadCategories()
        .then(() => {
          applyFilters();
        });

      vm.offSuccess = $transitions.onSuccess({}, transition => {
        applyFilters();
      });
    };

    vm.$onDestroy = function () {
      vm.offSuccess();
    };

    function loadCategories() {
      if (vm.prevFrom && vm.prevFrom.getTime() === vm.dates.from.value.getTime() &&
        vm.prevTo && vm.prevTo.getTime() === vm.dates.to.value.getTime()) {
        return;
      }

      vm.loading = true;
      vm.prevFrom = vm.dates.from.value;
      vm.prevTo = vm.dates.to.value;

      return EquipmentCategory
        .find(vm.dates.from.value, vm.dates.to.value)
        .then(categories => {
          vm.categories = categories;
          vm.category = vm.categories.find(current=> current.name === 'Camion');
          vm.loading = false;
        })
        .catch(err => {
          console.log(err);
          vm.loading = false;
        });
    }

    function applyFilters() {
      $root.$emit('filter:update', {
        from: vm.dates.from.value,
        to: vm.dates.to.value,
        category: vm.category
      });
    }
  }
})();