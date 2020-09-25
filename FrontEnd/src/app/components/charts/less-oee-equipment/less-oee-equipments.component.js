(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', '$translate', 'OEE', 'Utils'];

  angular
    .module('app')
    .component('lessOeeEquipmentsChart', {
      templateUrl: 'less-oee-equipments.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        from: '<',
        to: '<',
        categories: '<',
        equipments: '<',
        size: '<',
        onChartClick: '&'
      }
    });

  function Controller($root, $timeout, $element, $translate, OEE, Utils) {
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
      OEE
        .loadDataByEquipment(vm.from, vm.to, null, vm.categories, vm.equipments)
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
      const seriesData = {};
      let max = null;
      data = data.map(current => {
        const result = {category: current.category, data: {}};
        current.data.forEach(pair => {
          const value = Math.round(1000 * pair[1]) / 10;
          result.data[pair[0]] = value;
          max = !max || max < value ? value : max;
        });
        return result;
      });

      max = !max ? 100 : max + 20 - max % 10;
      max = max < 100 ? 100 : max;

      data.sort((a, b) => {
        if (b.data.OEE === 0 || a.data.OEE === 0) {
          return a.data.OEE - b.data.OEE;
        }
        return b.data.OEE - a.data.OEE;
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
      ['OEE', 'Utilization', 'CapacityPerformance', 'TimePerformance'].forEach(seriesId => {
        const category = seriesId === 'OEE' ? 'oee' : seriesId.charAt(0).toLowerCase() + seriesId.substring(1);
        const config = {
          id: seriesId,
          name: $translate.instant('components.oee._' + category),
          data: seriesData[seriesId],
          type: 'bar',
          barWidth: '15%',
          animation: false
        };
        if (seriesId === 'OEE') {
          config.color = '#59678c';
        }
        series.push(config);
      });

      const zoomStart = getZoomStart(data.length);
      const paddingLeft = Math.ceil(Utils.getTextWidth(longestName, '', {fontSize: '11px'})) + 30;

      let option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
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
          bottom: 50
        },
        xAxis: {
          type: 'value',
          name: '[%]',
          nameLocation: 'center',
          nameGap: 25,
          min: 0,
          max: max
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
        //vm.chart.on('click', onClick);
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
      const visibleBars = Math.floor((containerHeight - 150) / 60);
      if (visibleBars >= equipmentLength) {
        return 0;
      }
      return 100 * (1 - visibleBars / equipmentLength);
    }
  }
})();