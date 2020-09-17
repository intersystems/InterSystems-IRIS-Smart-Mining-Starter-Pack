(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', '$filter', 'LoadDump', 'Truck', 'Utils'];

  angular
    .module('app')
    .component('loadDumpByTruckChart', {
      templateUrl: 'load-dump-by-truck.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        date: '<',
        truck: '<',
        size: '<',
        onChartClick: '&',
        isLoading: '='
      }
    });

  function Controller($root, $timeout, $element, $filter, LoadDump, Truck, Utils) {
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
      vm.loading = true;
      if (typeof vm.isLoading !== 'undefined') {
        vm.isLoading = vm.loading;
      }

      let capacity;
      Truck
        .getCapacity(vm.truck.name)
        .then(result => {
          capacity = result;
          return LoadDump.getLoadAndDumpEvents(vm.truck.name, vm.date);
        })
        .then(data => {
          vm.loading = false;
          if (typeof vm.isLoading !== 'undefined') {
            vm.isLoading = vm.loading;
          }
          plotChart(data, capacity);
        })
        .catch(err => {
          vm.loading = false;
          if (typeof vm.isLoading !== 'undefined') {
            vm.isLoading = vm.loading;
          }
          console.log(err);
        });
    }

    function plotChart(data, capacity) {
      const eventMap = {
        loading: {label: 'Carga', color: 'rgba(97,109,214,.2)'},
        dumping: {label: 'Descarga', color: '#616dd6'}
      };

      const date = $filter('date')(vm.date, 'yyyy-MM-dd');

      const series = [{
        type: 'line',
        yAxisIndex: 1,
        step: 'end',
        color: '#c05050',
        id: 'accumulated',
        name: 'Toneladas Acumuladas',
        smooth: false,
        data: [],
        tooltip: {
          formatter: (params) => {
            const [date, value] = params.data;
            return `${params.marker} ${$filter('date')(date, 'HH:mm')}
              <div>Acumulado: ${value}</div>`;
          }
        }
      }];

      const mergedData = [];

      data.forEach(current => {
        const category = current.category.toLowerCase();
        let isDump = category === 'dumping';

        let sum = 0;
        current.data = current.data.filter(pair => {
          if (!pair[1]) {
            return false;
          }
          const minute = new Date(`${date} ${pair[0]}:00`);
          pair[0] = minute.getTime();
          pair[1] = Math.round(pair[1] * 10) / 10;
          pair.push(category);

          sum += pair[1];
          if (isDump) {
            series[0].data.push([pair[0], Math.round(sum * 10) / 10]);
          }
          return true;
        });

        Array.prototype.push.apply(mergedData, current.data);
      });

      mergedData.sort((a, b) => a[0] - b[0]);

      const capacitySeries = {
        type: 'line',
        step: 'end',
        name: 'Carga-Descarga',
        color: 'rgba(97,109,214,.2)',
        smooth: false,
        data: [],
        areaStyle: {opacity: .1},
        tooltip: {
          formatter: (params) => {
            const [date, value] = params.data;
            return `${$filter('date')(date, 'HH:mm')} - ${!value ? 'Descarga' : 'Carga'} 
              <div>${value ? value + ' Toneladas' : ''}</div>`;
          }
        },
        markLine: {
          silent: true,
          lineStyle: {color: '#999999', width: 2},
          symbol: 'none',
          label: {position: 'insideStartTop', formatter: '{b}: {c}'},
          data: [{
            name: 'Capacidad',
            yAxis: capacity
          }]
        }
      };
      series.push(capacitySeries);
      for (let current of mergedData) {
        const type = current[2];
        capacitySeries.data.push([current[0], type === 'dumping' ? 0 : current[1]]);
      }

      let option = {
        legend: {},
        tooltip: {},
        grid: {
          left: 70,
          top: 40,
          right: 70,
          bottom: 60
        },
        xAxis: {
          type: 'time',
          name: 'Hora del día',
          nameLocation: 'center',
          nameGap: 40
        },
        yAxis: [{
          type: 'value',
          name: 'Toneladas',
          nameGap: 40,
          nameLocation: 'center'
        }, {
          type: 'value',
          name: 'Toneladas Acumuladas',
          nameLocation: 'center',
          nameGap: 50,
          min: 0
        }],
        series: series
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
      if (params.seriesId === 'accumulated' && typeof vm.onChartClick === 'function') {
        $timeout(() => {
          vm.onChartClick({params: params, from: vm.from, to: vm.to});
        });
      }
    }
  }
})();