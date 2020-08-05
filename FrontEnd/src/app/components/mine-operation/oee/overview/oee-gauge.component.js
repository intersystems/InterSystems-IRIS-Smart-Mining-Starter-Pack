(() => {
  const angular = window.angular;

  Controller.$inject = ['$element', '$timeout', '$filter'];

  angular
    .module('app')
    .component('oeeGauge', {
      templateUrl: 'oee-gauge.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        value: '<',
        valueInterval: '<',
        size: '<',
        chartTitle: '<',
        color: '<'
      }
    });

  function Controller($element, $timeout, $filter) {
    const vm = this;

    vm.$postLink = function () {
      vm.jqContainer = $element.find('.chart');
      vm.container = vm.jqContainer[0];
      vm.valueInterval = vm.valueInterval || [60, 90];
      $timeout(() => {
        plotChart();
      }, 100);
    };

    vm.$onDestroy = function () {
      if (vm.chart) {
        echarts.dispose(vm.chart);
      }
    };

    function plotChart() {
      const max = vm.valueInterval[1];
      const min = vm.valueInterval[0];
      const now = new Date();
      now.setDate(now.getDate() - 8);
      const categories = [];
      for (let i = 0; i < 7; i++) {
        now.setDate(now.getDate() + 1);
        categories.push($filter('date')(now, 'dd-MM-yyyy'));
      }

      const data = [];
      for (let i = 0; i < categories.length - 1; i++) {
        data.push(Math.floor(10 * Math.random() * (max - min + 1)) / 10 + min);
      }
      data.push(vm.value);

      if (isNaN(vm.value)) {
        if (vm.chart) {
          echarts.dispose(vm.chart);
        }
        return;
      }

      $timeout(() => {
        const option = {
          tooltip: {},
          grid: {
            left: 30,
            right: 15,
            top: 25,
            bottom: 15
          },
          xAxis: {
            type: 'category',
            data: categories,
            axisTick: {show: false},
            axisLabel: {show: false, fontSize: 11},
            splitLine: {
              show: false
            },
            boundaryGap: false
          },
          yAxis: {
            type: 'value',
            axisTick: {show: false},
            axisLabel: {show: true, fontSize: 11},
            max: 100,
            min: min - min * .5,
            splitLine: {
              show: false
            }
          },
          series: [{
            color: vm.color,
            name: vm.chartTitle,
            type: 'line',
            data: data,
            smooth: false,
            symbolSize: 8,
            markPoint: {
              data: [{
                value: data[data.length - 1] + '%',
                coord: [data.length - 1, data[data.length - 1]],
                name: 'Valor Actual'
              }]
            }
          }]
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
      }, 50);

    }
  }
})();