(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', 'OEE', '$transitions'];

  angular
    .module('app')
    .component('oeeDefaultFilter', {
      templateUrl: 'default-filter.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller($root, OEE, $transitions) {
    const vm = this;

    vm.$onInit = function () {
      vm.applyFilters = applyFilters;
      vm.loadEquipments = loadEquipments;

      vm.dates = {
        from: {value: new Date('2017/12/31'), open: false},
        to: {value: new Date('2018/01/05'), open: false},
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

      return OEE
        .categories(vm.dates.from.value, vm.dates.to.value)
        .then(categories => {
          vm.categories = categories || [];

          const truckCategory = vm.categories.find(current => current.name === 'Camion');

          if (truckCategory) {
            vm.selectedCategories = [truckCategory];
          } else {
            vm.selectedCategories = vm.categories.length ? [vm.categories[0]] : [];
          }
          loadEquipments(true);
        })
        .then(equipments => {
          vm.loading = false;
        })
        .catch(err => {
          console.log(err);
          vm.loading = false;
        });
    }

    function loadEquipments(notShowLoading) {
      if (!vm.selectedCategories.length) {
        vm.equipments = [];
        vm.selectedEquipements = [];
        return;
      }

      if (!notShowLoading) {
        vm.loading = true;
      }
      return OEE.equipments(vm.dates.from.value, vm.dates.to.value, vm.selectedCategories)
        .then(equipments => {
          vm.equipments = equipments || [];
          vm.selectedEquipements = [];
          if (!notShowLoading) {
            vm.loading = false;
          }
        })
        .catch(err => {
          console.log(err);
          if (!notShowLoading) {
            vm.loading = false;
          }
        });
    }

    function applyFilters() {
      $root.$emit('filter:update', {
        from: vm.dates.from.value,
        to: vm.dates.to.value,
        categories: vm.selectedCategories,
        equipments: vm.selectedEquipements
      });
    }
  }
})();