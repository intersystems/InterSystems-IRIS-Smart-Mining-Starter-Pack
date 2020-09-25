(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', 'ProductionEventsEquipment', 'ProductionEventsShift', '$transitions'];

  angular
    .module('app')
    .component('productionFilter', {
      templateUrl: 'production-filter.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller($root, ProductionEventsEquipment, ProductionEventsShift, $transitions) {
    const vm = this;

    vm.$onInit = function () {
      vm.applyFilters = applyFilters;
      vm.onSelectShift = onSelectShift;

      vm.day = {
        value: new Date('2018/01/01'),
        open: false,
        options: {
          showWeeks: false,
          showMeridian: false
        },
        onClose: function (args) {
          loadTrucks();
        }
      };

      loadShifts()
        .then(() => {
          return loadTrucks();
        })
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

    function onSelectShift() {
      loadTrucks();
    }

    function loadShifts() {
      return ProductionEventsShift
        .findByDate(vm.day.value)
        .then(shifts => {
          console.log(shifts);
          shifts.sort((a, b) => b.id - a.id);
          vm.shifts = shifts;
          vm.shift = vm.shifts[0];
        })
        .catch(err => {
          console.log(err);
          vm.loading = false;
        });
    }

    function loadTrucks() {
      if (!vm.shift) {
        vm.trucks = [];
        vm.selectedTrucks = [];
        return;
      }

      vm.loading = true;
      return ProductionEventsEquipment
        .findByShift(vm.shift.id)
        .then(trucks => {
          vm.trucks = trucks;
          vm.selectedTrucks = vm.trucks.slice(0, 4);
          vm.loading = false;
        })
        .catch(err => {
          console.log(err);
          vm.loading = false;
        });
    }

    function applyFilters() {
      $root.$emit('filter:update', {
        date: vm.day.value,
        shift: vm.shift,
        trucks: vm.selectedTrucks
      });
    }
  }
})();