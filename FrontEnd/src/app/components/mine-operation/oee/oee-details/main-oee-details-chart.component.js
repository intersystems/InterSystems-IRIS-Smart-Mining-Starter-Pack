(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', 'DateUtils', '$filter', 'OEE', 'Equipment'];

  angular
    .module('app')
    .component('mainOeeDetailsChart', {
      templateUrl: 'main-oee-details-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {}
    });

  function Controller($root, $timeout, $element, DateUtils, $filter, OEE, Equipment) {
    const vm = this;

    vm.$onInit = function () {
      const container = $element.find('.chart');
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

        OEE.loadDataAsDays(vm.from, vm.to, null, vm.filters.categories, vm.filters.equipments)
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

      const defaultSeries = {
        data: [],
        type: 'bar'
      };

      let series = [];
      let oee = chartData.find(current => current.category === 'OEE');

      series.push({
        type: 'line',
        id: 'oee',
        smooth: false,
        symbolSize: 8,
        color: '#333',
        name: 'OEE',
        data: oee.data.map(pair => Math.round(1000 * pair[1]) / 10),
        label: {
          show: true,
          position: 'top',
          formatter: (params) => params.data + '%',
          color: '#fff'
        }
      });

      ['Utilization', 'CapacityPerformance', 'TimePerformance'].forEach(seriesId => {
        const current = chartData.find(current => current.category === seriesId);
        const config = angular.copy(defaultSeries);
        config.name = current.category;
        config.data = current.data.map(pair => Math.round(1000 * pair[1]) / 10);
        series.push(config);
      });

      let option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
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
          name: '[%]',
          nameLocation: 'center',
          nameGap: 50,
          min: 0,
          //max: max,
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

      const date = moment(params.name, 'MMM D YYYY').toDate();
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