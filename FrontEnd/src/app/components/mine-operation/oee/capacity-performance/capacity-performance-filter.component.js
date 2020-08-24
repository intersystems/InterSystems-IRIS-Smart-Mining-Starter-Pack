(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', 'OEE', '$transitions'];

  angular
    .module('app')
    .component('capacityPerformanceFilter', {
      templateUrl: 'capacity-performance-filter.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller($root, OEE, $transitions) {
    const vm = this;

    vm.$onInit = function () {
      vm.applyFilters = applyFilters;

      vm.dates = {
        from: {value: new Date('2017/12/31'), open: false},
        to: {value: new Date('2018/01/05'), open: false},
        options: {showWeeks: false, showMeridian: false},
        onClose: function (args) {
          loadTrucks();
        }
      };

      loadTrucks()
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

    function loadTrucks() {
      if (vm.prevFrom && vm.prevFrom.getTime() === vm.dates.from.value.getTime() &&
        vm.prevTo && vm.prevTo.getTime() === vm.dates.to.value.getTime()) {
        return;
      }

      vm.loading = true;
      vm.prevFrom = vm.dates.from.value;
      vm.prevTo = vm.dates.to.value;

      return OEE.equipments(vm.dates.from.value, vm.dates.to.value, {name: 'Camion'})
        .then(equipments => {
          vm.equipments = equipments || [];
          vm.selectedEquipements = [];
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
        equipments: vm.selectedEquipements
      });
    }
  }
})();