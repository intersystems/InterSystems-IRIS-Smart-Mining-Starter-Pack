(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', '$translate', 'DateUtils', '$filter', 'OEE', 'LoadDump'];

  angular
    .module('app')
    .component('mainCapacityPerformanceChart', {
      templateUrl: 'main-capacity-performance-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {}
    });

  function Controller($root, $timeout, $element, $translate, DateUtils, $filter, OEE, LoadDump) {
    const vm = this;

    vm.$onInit = function () {
      const container = $element.find('.chart');

      vm.lessPerformanceClick = lessPerformanceClick;
      vm.dumpEventClick = dumpEventClick;

      vm.container = container[0];

      vm.loading = true;
      vm.offFilters = $root.$on('filter:update', (e, filters) => {
        vm.filters = angular.copy(filters);

        vm.from = vm.filters.from;
        vm.to = vm.filters.to;
        vm.loading = true;

        vm.selectedDate = null;
        vm.selectedEquipments = null;
        vm.selectedStatus = null;
        vm.trucks = vm.filters.equipments;

        OEE.capacityPerformance(vm.from, vm.to, 'EventDateTimeDay', vm.trucks)
          .then(result => {
            vm.loading = false;
            plotChart(result);
          })
          .catch(err => {
            vm.loading = false;
            console.log(err);
          });
      });
    };

    vm.$onChanges = function (changes) {
      if (changes.data && vm.data) {
        $timeout(() => {
          plotChart(vm.data);
        });
      }
    };

    vm.$onDestroy = function () {
      if (vm.chart) {
        echarts.dispose(vm.chart);
      }

      vm.offFilters();
    };

    function plotChart(chartData) {
      chartData = angular.copy(chartData);
      const categories = [];
      for (let date = new Date(vm.from.getTime()); date <= vm.to; date.setDate(date.getDate() + 1)) {
        categories.push($filter('date')(date, 'MMM d yyyy'));
      }

      const tons = chartData[0];
      const performance = chartData[1];

      const series = [{
        type: 'bar',
        barWidth: '50%',
        name: $translate.instant('components.charts.all.tons_total'),
        data: tons.data.map(current => {
          current[1] = Math.round(current[1] / 1000);
          return current;
        }),
        label: {
          show: true,
          fontSize: 11
        }
      }, {
        type: 'line',
        name: $translate.instant('components.oee._capacityPerformance'),
        data: performance.data,
        yAxisIndex: 1,
        color: '#59678c',
        label: {
          show: true,
          fontSize: 11,
          formatter: (params) => params.data[1] + '%'
        }
      }];

      let max = null;
      for (let pair of performance.data) {
        let value = Math.round(1000 * pair[1]) / 10;
        if (value === 0) {
          continue;
        }

        max = max === null || max < value ? value : max;
        pair[1] = value;
      }

      max = !max ? 100 : max + 20 - max % 10;
      max = max < 100 ? 100 : max;


      let option = {
        tooltip: {},
        legend: {},
        grid: {
          left: 100,
          top: 40,
          right: 80,
          bottom: 60
        },
        yAxis: [{
          type: 'value',
          name: $translate.instant('components.charts.all.tons_thousands'),
          nameLocation: 'center',
          nameGap: 70,
          min: 0
        }, {
          type: 'value',
          name: $translate.instant('components.oee.overview.capacityPercent'),
          nameLocation: 'center',
          nameGap: 40,
          min: 0,
          max: max
        }],
        xAxis: {
          type: 'category',
          data: categories,
          name: $translate.instant('components.charts.all.date'),
          nameLocation: 'center',
          nameGap: 30
        },
        series: series
      };


      if (vm.chart) {
        echarts.dispose(vm.chart);
      }

      if (!vm.chart || vm.chart.isDisposed()) {
        vm.chart = echarts.init(vm.container, 'custom');
        vm.chart.on('click', onChartClick);
      }

      vm.chart.clear();
      vm.chart.setOption(option);
      vm.chart.resize();
    }

    function onChartClick(params) {
      if (params.componentType !== 'series') {
        return;
      }

      const date = moment(params.value[0], 'MMM D YYYY').toDate();
      if (date === vm.selectedDate) {
        return;
      }

      $timeout(() => {
        vm.selectedEquipments = null;
        vm.selectedDate = date;
      });
    }

    function lessPerformanceClick(params, from, to) {
      vm.selectedStatus = null;
      vm.selectedMinute = null;
      vm.details = null;
      if (params.componentType !== 'series') {
        return;
      }
      const equipmentName = params.data[1];
      vm.truck = equipmentName ? {name: equipmentName} : null;
    }

    function dumpEventClick(params) {
      if (params.componentType !== 'series') {
        return;
      }
      const [minute, value] = params.data;

      vm.selectedMinute = new Date(minute);
      vm.detailsLoading = true;
      LoadDump
        .getDumpDetails(vm.truck.name, vm.selectedMinute)
        .then(data => {
          vm.detailsLoading = false;
          vm.details = data;
          vm.details.accumulated = value;
        });
    }
  }
})();