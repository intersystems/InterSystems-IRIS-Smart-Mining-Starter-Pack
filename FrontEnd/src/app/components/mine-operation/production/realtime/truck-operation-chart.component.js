(() => {

  Controller.$inject = ['$rootScope', '$element', 'Truck', 'LoadDump'];

  angular
    .module('app')
    .component('truckOperationChart', {
      templateUrl: 'truck-operation-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {}
    });

  function Controller($root, $element, Truck, LoadDump) {
    const vm = this;

    const CHART_HEIGHT = 550;
    const HEIGHT_RATIO = 0.6;
    const DIM_CATEGORY_INDEX = 0;
    const DIM_TIME_START = 1;
    const DIM_TIME_FINISH = 2;


    vm.$onInit = function () {
      const container = $element.find('.chart');
      container.height(CHART_HEIGHT);
      vm.container = container[0];

      vm.filters = {};
      vm.offFilters = $root.$on('filter:update', (e, filters) => {
        vm.filters = angular.copy(filters);
        vm.trucks = vm.filters.trucks;

        if (!vm.trucks || !vm.trucks.length) {
          return;
        }

        vm.loading = true;

        LoadDump
          .getGanttData(vm.filters.trucks, vm.filters.date)
          .then(data => {
            vm.loading = false;
            plotChart(data);
          })
          .catch(err => {
            console.log(err);
          });
      });
    };

    vm.$onDestroy = function () {
      if (vm.offFilters) {
        vm.offFilters();
      }

      if (vm.chart) {
        echarts.dispose(vm.chart);
      }
    };

    function plotChart(_rawData) {
      const colors = [
        '#07a2a4',
        '#a3a1fb',
        '#616dd6',
        '#5fe2a0'
      ];
      const zoomStart = getZoomStart(_rawData.trucks.length);

      const series = Object.keys(_rawData.data).map((key, index) => {
        return {
          id: key,
          name: _rawData.data[key].name,
          itemStyle: {
            color: colors[index]
          },
          type: 'custom',
          renderItem: renderGanttItem,
          encode: {
            x: [DIM_TIME_START, DIM_TIME_FINISH],
            y: DIM_CATEGORY_INDEX,
            tooltip: [DIM_CATEGORY_INDEX, DIM_TIME_START, DIM_TIME_FINISH]
          },
          dimensions: _rawData.data[key].dimensions,
          data: _rawData.data[key].data
        };
      });


      series.push({
        id: 'names',
        type: 'custom',
        renderItem: renderAxisLabelItem,
        encode: {
          x: -1, // Then this series will not controlled by x.
          y: 0
        },
        data: _rawData.trucks.map((current, index) => [index, current])
      });

      const options = {
        legend: {},
        tooltip: {
          formatter: (params) => {
            if (params.seriesId === 'names') {
              return;
            }
            const truck = _rawData.trucks[params.value[0]];
            return `${truck} | ${params.seriesName}
            <br/> ${params.marker} Inicio:  ${moment(params.value[1]).format('YYYY-MM-DD HH:mm:ss')}
            <br/> ${params.marker} Fin:  ${moment(params.value[2]).format('YYYY-MM-DD HH:mm:ss')}`;
          }
        },
        animation: false,
        dataZoom: [{
          type: 'slider',
          xAxisIndex: 0,
          filterMode: 'weakFilter',
          height: 20,
          bottom: 0,
          start: 0,
          end: 26,
          handleIcon: 'M10.7,11.9H9.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4h1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
          handleSize: '80%',
          showDetail: false
        }, {
          type: 'inside',
          id: 'insideX',
          xAxisIndex: 0,
          filterMode: 'weakFilter',
          start: 0,
          end: 26,
          zoomOnMouseWheel: false,
          moveOnMouseMove: true
        }, {
          type: 'slider',
          yAxisIndex: 0,
          zoomLock: true,
          width: 10,
          right: 10,
          top: 70,
          bottom: 20,
          start: zoomStart,
          end: 100,
          handleSize: 0,
          showDetail: false
        }, {
          type: 'inside',
          id: 'insideY',
          yAxisIndex: 0,
          start: zoomStart,
          end: 100,
          zoomOnMouseWheel: false,
          moveOnMouseMove: true,
          moveOnMouseWheel: true
        }],
        grid: {
          show: true,
          top: 70,
          bottom: 20,
          left: 150,
          right: 20,
          backgroundColor: '#fff',
          borderWidth: 0
        },
        xAxis: {
          type: 'time',
          position: 'top',
          splitLine: {
            lineStyle: {
              color: ['#E9EDFF']
            }
          },
          axisLine: {
            show: false
          },
          axisTick: {
            lineStyle: {
              color: '#929ABA'
            }
          },
          axisLabel: {
            color: '#929ABA',
            inside: false,
            align: 'center'
          }
        },
        yAxis: {
          axisTick: {show: false},
          splitLine: {show: false},
          axisLine: {show: false},
          axisLabel: {show: false},
          min: 0,
          max: _rawData.trucks.length
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
      vm.chart.setOption(options);
      vm.chart.resize();
    }

    function renderGanttItem(params, api) {
      var categoryIndex = api.value(DIM_CATEGORY_INDEX);
      var startTime = api.coord([api.value(DIM_TIME_START), categoryIndex]);
      var finishTime = api.coord([api.value(DIM_TIME_FINISH), categoryIndex]);

      var barLength = finishTime[0] - startTime[0];
      // Get the heigth corresponds to length 1 on y axis.
      var barHeight = api.size([0, 1])[1] * HEIGHT_RATIO;
      // var barHeight = 30;
      var x = startTime[0];
      var y = startTime[1] - barHeight;

      /*var flightNumber = api.value(3) + '';
      var flightNumberWidth = echarts.format.getTextRect(flightNumber).width;
      var text = (barLength > flightNumberWidth + 40 && x + barLength >= 180)
        ? flightNumber : '';*/

      var rectNormal = clipRectByRect(params, {
        x: x, y: y, width: barLength, height: barHeight
      });
      /*var rectText = clipRectByRect(params, {
        x: x, y: y, width: barLength, height: barHeight
      });*/

      return {
        type: 'group',
        children: [{
          type: 'rect',
          ignore: !rectNormal,
          shape: rectNormal,
          style: api.style()
        }]
      };
    }

    function renderAxisLabelItem(params, api) {
      var y = api.coord([0, api.value(0)])[1];
      if (y < params.coordSys.y + 5) {
        return;
      }

      const textWidth = echarts.format.getTextRect(api.value(1)).width;
      const barHeight = api.size([0, 1])[1] * HEIGHT_RATIO / 2;

      return {
        type: 'group',
        position: [
          textWidth / 2,
          y - barHeight + 5
        ],
        children: [{
          type: 'text',
          style: {
            x: 10,
            y: 0,
            textVerticalAlign: 'bottom',
            textAlign: 'center',
            text: api.value(1),
            textFill: '#000'
          }
        }]
      };
    }


    function clipRectByRect(params, rect) {
      return echarts.graphic.clipRectByRect(rect, {
        x: params.coordSys.x,
        y: params.coordSys.y,
        width: params.coordSys.width,
        height: params.coordSys.height
      });
    }

    function getZoomStart(trucksLength) {
      const visibleBars = Math.floor((CHART_HEIGHT - 150) / 40);
      if (visibleBars >= trucksLength) {
        return 0;
      }
      return 100 * (1 - visibleBars / trucksLength);
    }
  }
})();