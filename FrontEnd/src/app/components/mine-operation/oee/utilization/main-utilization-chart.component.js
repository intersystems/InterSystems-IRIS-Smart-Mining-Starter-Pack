(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', 'DateUtils', '$filter', 'OEE', 'Equipment'];

  angular
    .module('app')
    .component('mainUtilizationChart', {
      templateUrl: 'main-utilization-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {}
    });

  function Controller($root, $timeout, $element, DateUtils, $filter, OEE, Equipment) {
    const vm = this;

    vm.$onInit = function () {
      const container = $element.find('.chart');
      vm.options = {
        title: 'Utilización por día',
        yAxisLabel: '% de tiempo',
        color: '#a3a1fb'
      };

      vm.lessProductiveChartClick = lessProductiveChartClick;
      vm.statusChartClick = statusChartClick;

      vm.container = container[0];

      vm.loading = true;
      vm.offFilters = $root.$on('filter:update', (e, filters) => {
        vm.filters = angular.copy(filters);

        if (!vm.filters.categories || !vm.filters.categories.length) {
          return;
        }

        vm.from = vm.filters.from;
        vm.to = vm.filters.to;
        vm.categories = vm.filters.categories;
        vm.loading = true;

        vm.selectedDate = null;
        vm.selectedEquipments = null;
        vm.selectedStatus = null;

        const chartData = {};
        OEE.loadDataAsDays(vm.from, vm.to, 'Utilization', vm.filters.categories, vm.filters.equipments)
          .then(result => {
            chartData.capacityPerformance = result && result[0] ? result[0].data : [];
            return Equipment.statusData(vm.from, vm.to, vm.filters.categories, vm.filters.equipments, 'day');
          })
          .then(result => {
            chartData.status = result;
            vm.loading = false;
            plotChart(chartData);
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

      const defaultSeries = {
        data: [],
        type: 'bar',
        stack: 'stack',
        barWidth: '50%',
        label: {
          show: true,
          fontSize: 11,
          formatter: (params) => params.data[1] + '%'
        }
      };

      let series = {};
      ['Operative', 'Delay', 'Standby', 'Downtime'].forEach(current => {
        series[current] = angular.copy(defaultSeries);
        series[current].name = current;
      });

      chartData.status.forEach(current => {
        const minute = current.category;
        const total = current.data.reduce((sum, current) => current[1] + sum, 0);
        for (const pair of current.data) {
          series[pair[0]].data.push([minute, Math.round(10000 * pair[1] / total) / 100]);
        }
      });

      series = Object.values(series);

      let max = null;
      for (let pair of chartData.capacityPerformance) {
        let value = Math.round(1000 * pair[1]) / 10;
        if (value === 0) {
          continue;
        }

        max = max === null || max < value ? value : max;
        pair[1] = value;
      }

      /*series.push({
        type: 'line',
        id: 'utilization',
        smooth: false,
        symbolSize: 8,
        color: '#333',
        name: vm.options.title,
        data: chartData.utilization,
        label: {
          show: true,
          position: 'top',
          formatter: (params) => params.data[1] + '%',
          color: '#fff'
        }
      });*/

      max = !max ? 100 : max + 20 - max % 10;
      max = max < 100 ? 100 : max;

      let option = {
        tooltip: {},
        legend: {},
        grid: {
          left: 80,
          top: 40,
          right: 20,
          bottom: 60
        },
        yAxis: {
          type: 'value',
          axisLabel: {fontSize: 11, show: true},
          name: '% de tiempo',
          nameLocation: 'center',
          nameGap: 50,
          min: 0,
          max: max,
          nameTextStyle: {
            color: '#333333',
            fontSize: 16
          }
        },
        xAxis: {
          type: 'category',
          data: categories,
          axisLabel: {fontSize: 11, show: true},
          name: 'Fecha',
          nameLocation: 'center',
          nameGap: 30,
          nameTextStyle: {
            color: '#333333',
            fontSize: 16
          }
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

    function lessProductiveChartClick(params, from, to) {
      vm.selectedStatus = null;
      if (params.componentType !== 'series') {
        return;
      }
      const equipmentName = params.data[1];
      vm.selectedEquipments = equipmentName ? [{name: equipmentName}] : null;
    }

    function statusChartClick(params) {
      if (params.componentType !== 'series') {
        return;
      }
      vm.selectedStatus = params.seriesName;
    }
  }
})();