(() => {

  Controller.$inject = ['$rootScope', '$element', 'Truck', 'LoadDump'];

  angular
    .module('app')
    .component('equipmentProductionStatusChart', {
      templateUrl: 'equipment-production-status-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {}
    });

  function Controller($rootScope, $element, Truck, LoadDump) {
    const vm = this;

    vm.$onInit = function () {
      vm.container = $element.find('.chart')[0];
      vm.filters = {};
      vm.trucks = [];

      vm.offFilters = $rootScope.$on('filter:update', (e, filters) => {
        vm.filters = angular.copy(filters);
        vm.loading = true;
        Truck
          .getProductionByHourOfDay(vm.filters.date, vm.filters.trucks)
          .then(production => {
            vm.loading = false;
            plotChart(production);
          })
          .catch(err => {
            console.log(err);
          });
      });
    };

    vm.$onDestroy = function () {
      if (vm.offFilters) {
        vm.offFilters();
      }
    };

    function plotChart(data) {
      const series = [];
      const categories = data.length ? data[0].categories : [];

      data.forEach(current => {
        series.push({
          name: current.equipmentName,
          data: current.values,
          type: 'bar',
          stack: 'stack'
        });
      });

      const option = {
        tooltip: {},
        grid: {
          left: 80,
          top: 60,
          right: 30,
          bottom: 60
        },
        yAxis: {
          type: 'value',
          axisLabel: {fontSize: 11},
          name: 'Toneladas',
          nameLocation: 'center',
          nameGap: 50,
          nameTextStyle: {
            color: '#333333',
            fontSize: 16
          }
        },
        xAxis: {
          type: 'category',
          data: categories,
          axisLabel: {fontSize: 11},
          name: 'Horas',
          nameLocation: 'center',
          nameGap: 30,
          nameTextStyle: {
            color: '#333333',
            fontSize: 16
          }
        },
        series: series,
        legend: {
          show: true,
          padding: [20, 0, 0, 0],
          data: series.map(current => current.name)
        }
      };

      if (vm.chart) {
        echarts.dispose(vm.chart);
      }

      if (!vm.chart || vm.chart.isDisposed()) {
        vm.chart = echarts.init(vm.container, 'custom');
      }

      vm.chart.clear();
      vm.chart.setOption(option);
      vm.chart.resize();
    }
  }
})();