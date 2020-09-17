(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', 'DateUtils', '$filter', 'OEE', 'IrisUtils', '$translate'];

  angular
    .module('app')
    .component('mainTimePerformanceChart', {
      templateUrl: 'main-time-performance-chart.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {}
    });

  function Controller($root, $timeout, $element, DateUtils, $filter, OEE, IrisUtils) {
    const vm = this;

    vm.$onInit = function () {
      const container = $element.find('.chart');

      vm.lessPerformanceClick = lessPerformanceClick;
      vm.onSelectTrip = onSelectTrip;

      vm.container = container[0];

      vm.loading = true;
      vm.offFilters = $root.$on('filter:update', (e, filters) => {
        vm.filters = angular.copy(filters);

        vm.from = vm.filters.from;
        vm.to = vm.filters.to;
        vm.loading = true;

        vm.selectedDate = null;
        vm.selectedEquipments = null;
        vm.selectedStatus = null;
        vm.equipments = vm.filters.equipments;

        OEE.loadDataAsDays(vm.from, vm.to, 'TimePerformance', vm.filters.categories, vm.equipments)
          .then(result => {
            console.log(result);
            vm.loading = false;
            plotChart(result);
          })
          .catch(err => {
            vm.loading = false;
            console.log(err);
          });
      });
    };

    vm.$onChanges = function (changes) {
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

      vm.offFilters();
    };

    function plotChart(chartData) {
      chartData = angular.copy(chartData[0]);
      const categories = [];
      for (let date = new Date(vm.from.getTime()); date <= vm.to; date.setDate(date.getDate() + 1)) {
        categories.push($filter('date')(date, 'MMM d yyyy'));
      }

      const data = chartData.data;

      const series = [{
        type: 'bar',
        barWidth: '50%',
        name: $translate.instant('components.oee.time-performance.main-time-performance-chart.timePerfPerc'),
        data: data,
        label: {
          show: true,
          fontSize: 11,
          formatter: (params) => `${params.data[1]}%`
        }
      }];

      let max = null;
      for (let pair of data) {
        let value = Math.round(1000 * pair[1]) / 10;
        if (value === 0) {
          continue;
        }

        max = max === null || max < value ? value : max;
        pair[1] = value;
      }

      max = !max ? 100 : max + 20 - max % 10;
      max = max < 100 ? 100 : max;


      let option = {
        tooltip: {
          formatter: (params) => {
            return `<div>${params.seriesName}</div>${params.marker} ${params.data[0]}: ${params.data[1]}%`;
          }
        },
        grid: {
          left: 100,
          top: 10,
          right: 80,
          bottom: 60
        },
        yAxis: [{
          type: 'value',
          name: $translate.instant('components.oee.time-performance.main-time-performance-chart.timePerc'),
          nameLocation: 'center',
          nameGap: 70,
          min: 0
        }],
        xAxis: {
          type: 'category',
          data: categories,
          name: $translate.instant('components.oee.time-performance.main-time-performance-chart.date'),
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

      const date = moment(params.value[0], 'MMM D YYYY').toDate();
      if (date === vm.selectedDate) {
        return;
      }

      $timeout(() => {
        vm.selectedEquipments = null;
        vm.selectedDate = date;
      });
    }

    function lessPerformanceClick(params, from, to) {
      vm.selectedStatus = null;
      vm.selectedMinute = null;
      vm.details = null;
      if (params.componentType !== 'series') {
        return;
      }
      const equipmentName = params.data[1];
      vm.equipment = equipmentName ? {name: equipmentName} : null;
    }

    function onSelectTrip(trip) {
      trip = angular.copy(trip);
      const time = new Date(trip.time);
      const minuteNumber = IrisUtils.getMinuteNumber(time);
      const dateNumber = IrisUtils.getDateNumber(time);

      const query = `SELECT 
        NON EMPTY {
          [Measures].[TripTime],
          [Measures].[ReferenceTravelTime],
          [Measures].[MeasuredTons],
          [Measures].[CapacityMax]
        } ON 0,
        NON EMPTY HEAD(
          NONEMPTYCROSSJOIN(
            [ProductionEventStartTime].[H1].[ProductionEventStartTimeMinute].Members,
            [Trip].[H1].[TripName].Members
          ),2000,SAMPLE
        ) ON 1 
        FROM [ASPMINING.ANALYTICS.UNIFIEDEVENTSCUBE] 
        %FILTER NONEMPTYCROSSJOIN(
          [ProductionEventStartTime].[H1].[ProductionEventStartTimeMinute].&[${minuteNumber}],
          NONEMPTYCROSSJOIN(
            [Equipment].[H1].[EquipmentName].&[${vm.equipment.name}],
            [EventDateTime].[H1].[EventDateTimeDay].&[${dateNumber}]
          )
        )`;


      vm.detailsLoading = true;
      IrisUtils
        .executeQuery(query)
        .then(data => {
          trip.referenceTravelTime = data.Data[1];
          trip.measuredTons = data.Data[2];
          trip.truckCapacity = data.Data[3];

          vm.details = trip;
          vm.detailsLoading = false;
          console.log(data);
        })
        .catch(err => {
          console.log(err);
          vm.detailsLoading = false;
        });
    }
  }
})();