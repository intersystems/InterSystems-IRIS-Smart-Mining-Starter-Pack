(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', '$translate', 'Equipment', 'Truck', 'Utils'];

  angular
    .module('app')
    .component('lessTimePerformanceEquipmentsChart', {
      templateUrl: 'less-time-performance-equipments.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        from: '<',
        to: '<',
        trucks: '<',
        maxCategories: '<',
        size: '<',
        onChartClick: '&'
      }
    });


  function Controller($root, $timeout, $element, $translate, Equipment, Truck, Utils) {
    const vm = this;
    vm.$onInit = function () {
      const container = $element.find('.chart');
      vm.maxCategories = vm.maxCategories || 10;

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
      Truck
        .getTimePerformanceByDay(vm.from, vm.trucks)
        .then(data => {
          vm.loading = false;
          plotChart(data);
        })
        .catch(err => {
          vm.loading = false;
          console.log(err);
        });
    }

    function plotChart(production) {
      const data = production.find(current => current.category === 'TimePerformance').data;
      data.sort((a, b) => {
        if (b[1] === 0 || a[1] === 0) {
          return a[1] - b[1];
        }
        return b[1] - a[1];
      });

      let longestName = '';
      data.forEach(current => {
        current.reverse();
        current[0] = Math.round(1000 * current[0]) / 10;
        longestName = current[1].length > longestName.length ? current[1] : longestName;
      });

      const series = [{
        name: $translate.instant('components.oee._timePerformance'),
        data: data,
        type: 'bar',
        barWidth: '50%',
        animation: false,
        label: {
          show: true,
          fontSize: 11,
          position: 'right',
          color: '#333333',
          formatter: (params) => `${params.data[0]}%`
        }
      }];

      const zoomStart = getZoomStart(data.length);
      const paddingLeft = Math.ceil(Utils.getTextWidth(longestName, '', {fontSize: '11px'})) + 30;

      let option = {
        tooltip: {
          formatter: (params) => {
            const [value, truck] = params.data;
            return `${params.marker} ${truck}
            <div>${value}</div>`;
          }
        },
        dataZoom: [{
          type: 'slider',
          yAxisIndex: 0,
          zoomLock: true,
          width: 25,
          right: 0,
          start: zoomStart,
          end: 100,
          handleSize: 0,
          showDetail: false
        }],
        grid: {
          left: paddingLeft + 40,
          top: 10,
          right: 30,
          bottom: 50
        },
        xAxis: {
          type: 'value',
          name: $translate.instant('components.oee.overview.timePercent'),
          nameLocation: 'center',
          nameGap: 25
        },
        yAxis: {
          type: 'category',
          name: $translate.instant('components.charts.all.truck'),
          nameLocation: 'center',
          nameGap: paddingLeft
        },
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
      if (typeof vm.onChartClick === 'function') {
        $timeout(() => {
          vm.onChartClick({params: params, from: vm.from, to: vm.to});
        });
      }
    }

    function getZoomStart(equipmentLength) {
      const containerHeight = vm.container.offsetHeight;
      const visibleBars = Math.floor((containerHeight - 150) / 30);
      if (visibleBars >= equipmentLength) {
        return 0;
      }
      return 100 * (1 - visibleBars / equipmentLength);
    }
  }
})();