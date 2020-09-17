(() => {
  const angular = window.angular;

  Controller.$inject = ['$state'];

  angular
    .module('app')
    .component('oeeOverviewChart', {
      templateUrl: 'overview-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        type: '<',
        target: '<',
        chartTitle: '<',
        data: '<',
        from: '<',
        to: '<',
        categories: '<',
        equipments: '<',
        size: '<'
      }
    });

  function Controller($state) {
    const vm = this;

    vm.$postLink = function () {
      vm.options = {
        lastMarker: true,
        title: {show: false},
        xAxis: {name: false, labels: true},
        yAxis: {name: false, labels: true},
        series: {label: false}
      };

      vm.goToTarget = goToTarget;
    };

    vm.$onDestroy = function () {
    };

    function goToTarget() {
      if (!vm.target) {
        return;
      }
      $state.go(vm.target);
    }
  }
})();