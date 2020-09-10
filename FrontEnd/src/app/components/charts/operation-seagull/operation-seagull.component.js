(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', 'Equipment', 'Utils', 'DateUtils'];

  angular
    .module('app')
    .component('operationSeagullChart', {
      templateUrl: 'operation-seagull.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        from: '<',
        to: '<',
        categories: '<',
        equipments: '<',
        size: '<',
        onChartClick: '&',
        isLoading: '='
      }
    });

  function Controller($root, $timeout, $element, Equipment, Utils, DateUtils, $filter) {
    const vm = this;
    vm.$onInit = function () {
      const container = $element.find('.chart');
      vm.container = container[0];
      loadData();
    };

    vm.$onChanges = function () {
      if (!vm.container) {
        return;
      }

      loadData();
    };

    vm.$onDestroy = function () {
      if (vm.chart) {
        echarts.dispose(vm.chart);
      }
    };

    function loadData() {
      if ((!vm.categories || !vm.categories.length) && (!vm.equipments || !vm.equipments.length)) {
        if (vm.chart) {
          echarts.dispose(vm.chart);
        }
        return;
      }

      vm.loading = true;
      if (typeof vm.isLoading !== 'undefined') {
        vm.isLoading = vm.loading;
      }
      Equipment
        .statusData(vm.from, vm.to, vm.categories, vm.equipments)
        .then(data => {
          vm.loading = false;
          if (typeof vm.isLoading !== 'undefined') {
            vm.isLoading = vm.loading;
          }
          plotChart(data);
        })
        .catch(err => {
          vm.loading = false;
          if (typeof vm.isLoading !== 'undefined') {
            vm.isLoading = vm.loading;
          }
          console.log(err);
        });
    }

    function plotChart(data) {
      const categoryStep = 5;
      const categories = [];

      for (let i = 0; i < 24 * 60; i += categoryStep) {
        let hour = Math.floor(i / 60);
        let minute = i % 60;

        hour = ('0' + hour).slice(-2);
        minute = ('0' + minute).slice(-2);
        categories.push(`${hour}:${minute}`);
      }

      const defaultSeries = {
        data: [],
        type: 'bar',
        stack: 'stack',
        barWidth: '115%'
      };

      let series = {};
      ['Operative', 'Delay', 'Standby', 'Downtime'].forEach(current => {
        series[current] = angular.copy(defaultSeries);
        series[current].name = current;
      });

      data.forEach(current => {
        const minute = current.category;
        const total = current.data.reduce((sum, current) => current[1] + sum, 0);
        for (const pair of current.data) {
          series[pair[0]].data.push([minute, Math.round(10000 * pair[1] / total) / 100]);
          // series[pair[0]].data.push([minute, pair[1]]);
        }
      });

      series = Object.keys(series).map(current => series[current]);
      const option = {
        tooltip: {},
        grid: {
          left: 80,
          top: 30,
          right: 20,
          bottom: 60
        },
        yAxis: {
          type: 'value',
          axisLabel: {fontSize: 11},
          name: 'Porcentaje de tiempo',
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
          name: 'Hora del día',
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
          selectedMode: false,
          data: series.map(current => current.name)
        }
      };

      if (vm.chart) {
        echarts.dispose(vm.chart);
      }

      if (!vm.chart || vm.chart.isDisposed()) {
        vm.chart = echarts.init(vm.container, 'custom');
        vm.chart.on('click', onClick);
      }

      vm.chart.clear();
      vm.chart.setOption(option);
      vm.chart.resize();
    }

    function onClick(params) {
      if (typeof vm.onChartClick === 'function') {
        $timeout(() => {
          vm.onChartClick({params: params, from: vm.from, to: vm.to});
        });
      }
    }
  }
})();