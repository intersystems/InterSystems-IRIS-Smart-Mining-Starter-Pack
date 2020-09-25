(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', '$translate', 'Equipment', 'Utils'];

  angular
    .module('app')
    .component('lessProductiveEquipmentsChart', {
      templateUrl: 'less-productive-equipments.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        from: '<',
        to: '<',
        categories: '<',
        color: '<',
        maxCategories: '<',
        size: '<',
        onChartClick: '&',
        wait: '<'
      }
    });

  function Controller($root, $timeout, $element, $translate, Equipment, Utils) {
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
      $timeout(() => {
        Equipment
          .statusData(vm.from, vm.to, vm.categories, null, 'equipment')
          .then(data => {
            vm.loading = false;
            plotChart(data);
          })
          .catch(err => {
            vm.loading = false;
            console.log(err);
          });
      }, vm.wait);
    }

    function plotChart(data) {
      const seriesData = {};
      data = data.map(current => {
        const sum = current.data.reduce((sum, pair) => sum + pair[1], 0);
        const result = {category: current.category, data: {}};
        current.data.forEach(pair => {
          result.data[pair[0]] = sum !== 0 ? Math.round(1000 * pair[1] / sum) / 10 : null;
        });
        return result;
      });

      data.sort((a, b) => {
        if (b.data.Downtime === 100 || a.data.Downtime === 100) {
          return b.data.Downtime - a.data.Downtime;
        }
        if (a.data.Operative !== b.data.Operative) {
          return b.data.Operative - a.data.Operative;
        }

        if (a.data.Delay !== b.data.Delay) {
          return b.data.Delay - a.data.Delay;
        }

        if (a.data.Standby !== b.data.Standby) {
          return b.data.Standby - a.data.Standby;
        }

        return b.data.Downtime - a.data.Downtime;
      });
      // data = data.slice(0, vm.maxCategories);

      let longestName = '';
      data.forEach(current => {
        longestName = current.category.length > longestName.length ? current.category : longestName;
        Object.keys(current.data).forEach(status => {
          seriesData[status] = seriesData[status] || [];
          const value = current.data[status];
          if (value !== null) {
            seriesData[status].push([value, current.category]);
          }
        });
      });

      const series = [];
      for (let seriesId in seriesData) {
        series.push({
          id: seriesId,
          name: seriesId,
          data: seriesData[seriesId],
          type: 'bar',
          barWidth: '50%',
          stack: 'stack',
          animation: false
        });
      }

      const zoomStart = getZoomStart(data.length);
      const paddingLeft = Math.ceil(Utils.getTextWidth(longestName, '', {fontSize: '11px'})) + 30;

      let option = {
        tooltip: {},
        legend: {},
        dataZoom: [{
          type: 'slider',
          yAxisIndex: 0,
          zoomLock: true,
          width: 25,
          right: 10,
          start: zoomStart,
          end: 100,
          handleSize: 0,
          showDetail: false
        }],
        grid: {
          left: paddingLeft + 40,
          top: 30,
          right: 40,
          bottom: 60
        },
        xAxis: {
          type: 'value',
          name: $translate.instant('components.oee.overview.timePercent'),
          nameLocation: 'center',
          min: 0,
          max: 100,
          nameGap: 30
        },
        yAxis: {
          type: 'category',
          name: $translate.instant('components.charts.all.equipment'),
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