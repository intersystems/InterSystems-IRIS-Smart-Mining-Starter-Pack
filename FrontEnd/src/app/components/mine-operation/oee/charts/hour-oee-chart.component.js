(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', 'DateUtils', '$filter', 'OEE'];

  angular
    .module('app')
    .component('hourOeeChart', {
      templateUrl: 'hour-oee-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        type: '<',
        date: '<',
        categories: '<',
        equipments: '<',
        color: '<'
      }
    });

  function Controller($root, $timeout, $element, DateUtils, $filter, OEE) {
    const vm = this;

    vm.$onInit = function () {
      const container = $element.find('.chart');

      vm.types = {
        Utilization: {
          title: 'Utilización por hora',
          yAxisLabel: '% de tiempo'
        },
        CapacityPerformance: {
          title: 'Performace Capacidad por hora',
          yAxisLabel: '% de capacidad'
        },
        TimePerformance: {
          title: 'Performance Tiempo por hora',
          yAxisLabel: '% de tiempo'
        },
        OEE: ''
      };

      vm.container = container[0];
      loadData();
      vm.selectedDate = vm.date;
    };

    vm.$onChanges = function () {
      if (!vm.container) {
        return;
      }


      if (!vm.selectedDate || vm.selectedDate.getTime() !== vm.date.getTime()) {
        vm.selectedHour = null;
        loadData();
      }
      vm.selectedDate = vm.date;
    };

    vm.$onDestroy = function () {
      if (vm.chart) {
        echarts.dispose(vm.chart);
      }
    };

    function loadData() {
      vm.loading = true;
      OEE
        .loadDataAsHours(vm.date, vm.date, vm.type, vm.categories, vm.equipments)
        .then(data => {
          vm.loading = false;
          plotChart(data);
        })
        .catch(err => {
          vm.loading = false;
          console.log(err);
        });
    }

    function plotChart(data) {
      const categories = [];
      const series = [];

      for (let i = 0; i < 24; i++) {
        const hour = i % 12 === 0 ? 12 : i % 12;
        categories.push(hour + (i < 12 ? 'am' : 'pm'));
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
          name: vm.type,
          data: data,
          label: {
            show: true,
            position: 'top',
            formatter: (params) => params.data[1] + '%',
            color: '#666'
          },
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
      const option = {
        tooltip: {},
        grid: {
          left: 80,
          top: 30,
          right: 30,
          bottom: 60
        },
        yAxis: {
          type: 'value',
          axisLabel: {fontSize: 11},
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
          axisLabel: {fontSize: 11},
          name: 'Fecha',
          nameLocation: 'center',
          nameGap: 30,
          nameTextStyle: {
            color: '#333333',
            fontSize: 16
          }
        },
        visualMap: {
          show: false,
          type: 'piecewise',
          dimension: 0,
          pieces: [{
            lte: 8,
            color: '#a3a1fb'
          }, {
            gt: 8,
            lte: 20,
            color: '#5fe2a0'
          }, {
            gt: 20,
            color: '#a3a1fb'
          }]
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

      let hour = params.value[0];
      const suffix = hour.slice(-2);
      if (suffix === 'am') {
        hour = parseInt(hour) % 12;
      } else {
        hour = parseInt(hour) % 12 + 12;
      }

      const shift = params.seriesId;

      if (hour === vm.selectedHour) {
        return;
      }

      $timeout(() => {
        vm.color = params.color;
        vm.selectedHour = hour;
      });
    }
  }
})();