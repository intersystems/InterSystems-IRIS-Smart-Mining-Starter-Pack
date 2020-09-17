(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', 'DateUtils', '$filter', 'OEE', '$translate'];

  angular
    .module('app')
    .component('dayOeeChart', {
      templateUrl: 'day-oee-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        type: '<',
        options: '<',
        data: '<',
        from: '<',
        to: '<',
        categories: '<',
        equipments: '<',
        size: '<'
      }
    });

  function Controller($root, $timeout, $element, DateUtils, $filter, OEE, $translate) {
    const vm = this;

    vm.$onInit = function () {
      const container = $element.find('.chart');

      vm.types = {
        Utilization: {
          title: $translate.instant('components.oee.overview.day-oee-chart.dailyUtil'),
          yAxisLabel: $translate.instant('components.oee.overview.day-oee-chart.timePercent'),
          color: '#a3a1fb'
        },
        CapacityPerformance: {
          title: $translate.instant('components.oee.overview.day-oee-chart.capPerfPerDay'),
          yAxisLabel: $translate.instant('components.oee.overview.day-oee-chart.capPerfPercent'),
          color: '#59678c'
        },
        TimePerformance: {
          title: $translate.instant('components.oee.overview.day-oee-chart.timePerfPerDay'),
          yAxisLabel: $translate.instant('components.oee.overview.day-oee-chart.timePerfPercent'),
          color: '#ffb980'
        },
        OEE: {
          colors: '#5fe2a0'
        }
      };

      vm.container = container[0];

    };

    vm.$onChanges = function (changes) {
      vm.options = Object.assign({
        lastMarker: false,
        title: {show: true},
        yAxis: {name: true, labels: true},
        xAxis: {name: true, labels: true},
        series: {label: true}
      }, vm.options);

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
    };

    function plotChart(data) {
      const categories = [];
      const series = [];

      for (let date = new Date(vm.from.getTime()); date <= vm.to; date.setDate(date.getDate() + 1)) {
        categories.push($filter('date')(date, 'MMM d yyyy'));
      }

      const dataMap = {};
      data.forEach(current => {
        if (!dataMap[current.parent]) {
          dataMap[current.parent] = {};
        }

        current.data.reduce((map, pair) => {
          const date = pair[0];
          map[date] = map[date] || {};
          map[date][current.category] = pair[1];
          return map;
        }, dataMap[current.parent]);
      });

      let max = null;
      for (let type in dataMap) {
        const current = dataMap[type];
        const data = [];

        for (let day in current) {
          const _this = current[day];
          let value = Math.round(1000 * _this[vm.type]) / 10;
          if (value === 0) {
            continue;
          }
          max = max === null || max < value ? value : max;

          data.push([day, value]);
        }

        series.push({
          type: 'line',
          id: vm.type,
          smooth: false,
          symbolSize: 8,
          color: vm.types[vm.type].color,
          name: vm.types[vm.type].title,
          data: data,
          label: {
            show: vm.options.series.label,
            position: 'top',
            formatter: (params) => params.data[1] + '%',
            color: '#666'
          },
          markPoint: vm.options.lastMarker ? {
            data: [{
              value: data[data.length - 1][1] + '%',
              coord: [data.length - 1, data[data.length - 1][1]],
              name: $translate.instant('components.oee.overview.day-oee-chart.currentValue')
            }]
          } : null,
          markLine: {
            silent: true,
            lineStyle: {color: '#999999', width: 2},
            data: [[{
              symbol: 'none',
              coord: [categories[0], 100]
            }, {
              symbol: 'none',
              coord: [categories[categories.length - 1], 100]
            }]]
          }
        });
      }

      max = !max ? 100 : max + 20 - max % 10;
      max = max < 100 ? 100 : max;

      let option = {
        tooltip: {},
        grid: {
          left: vm.options.yAxis.name ? 80 : 30,
          top: 20,
          right: 20,
          bottom: vm.options.xAxis.name ? 60 : 20
        },
        yAxis: {
          type: 'value',
          axisLabel: {show: vm.options.yAxis.labels},
          name: $translate.instant('components.oee.overview.day-oee-chart.timePerfPercent'),
          nameLocation: 'center',
          nameGap: 50,
          min: 0,
          max: max
        },
        xAxis: {
          type: 'category',
          data: categories,
          axisLabel: {show: vm.options.xAxis.labels},
          name: $translate.instant('components.oee.overview.day-oee-chart.date'),
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
      }

      vm.chart.clear();
      vm.chart.setOption(option);
      vm.chart.resize();
    }
  }
})();