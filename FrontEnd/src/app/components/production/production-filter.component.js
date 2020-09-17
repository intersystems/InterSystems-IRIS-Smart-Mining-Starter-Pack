(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', 'Truck', '$transitions'];

  angular
    .module('app')
    .component('productionFilter', {
      templateUrl: 'production-filter.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller($root, Truck, $transitions) {
    const vm = this;

    vm.$onInit = function () {
      vm.applyFilters = applyFilters;

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
      vm.loading = true;
      return Truck
        .find(vm.day.value)
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
        trucks: vm.selectedTrucks
      });
    }
  }
})();