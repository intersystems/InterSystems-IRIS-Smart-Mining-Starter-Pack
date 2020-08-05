(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', 'DateUtils', '$filter', 'OEE'];

  angular
    .module('app')
    .component('minuteOeeChart', {
      templateUrl: 'minute-oee-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        type: '<',
        date: '<',
        hour: '<',
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
          title: 'Utilización por minuto',
          yAxisLabel: '% de tiempo'
        },
        CapacityPerformance: {
          title: 'Performace Capacidad por minuto',
          yAxisLabel: '% de capacidad'
        },
        TimePerformance: {
          title: 'Performance Tiempo por minuto',
          yAxisLabel: '% de tiempo'
        },
        OEE: ''
      };

      vm.container = container[0];
      loadData();
      vm.hourString = DateUtils.pad(vm.hour);
      vm.selectedDate = vm.date;
    };

    vm.$onChanges = function () {
      if (!vm.container || !vm.date) {
        return;
      }

      if (!vm.selectedDate || vm.selectedDate.getTime() !== vm.date.getTime() || vm.hour !== vm.selectedHour) {
        loadData();
      }
      vm.selectedDate = vm.date;
      vm.seletectHour = vm.hour;
      vm.hourString = DateUtils.pad(vm.hour);
    };

    vm.$onDestroy = function () {
      if (vm.chart) {
        echarts.dispose(vm.chart);
      }
    };

    function loadData() {
      vm.loading = true;
      OEE
        .loadDataAsMinutes(vm.date, vm.hour, vm.type, vm.categories, vm.equipments)
        .then(data => {
          vm.loading = false;
          vm.data = data;
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

      for (let i = 0; i < 60; i++) {
        categories.push(i);
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

        for (let _minute in current) {
          const _this = current[_minute];
          let value = Math.round(1000 * _this[vm.type]) / 10;

          let [hour, minute] = _minute.split(':');
          hour = parseInt(hour);
          minute = parseInt(minute);
          if (hour === vm.hour) {
            max = max === null || max < value ? value : max;
            data.push([minute, value]);
          }
        }

        series.push({
          type: 'line',
          id: vm.type,
          smooth: false,
          symbolSize: 8,
          name: vm.type,
          data: data,
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