(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', '$filter', 'IrisUtils', 'Utils'];

  angular
    .module('app')
    .component('tripsByTruckChart', {
      templateUrl: 'trips-by-truck.template.html',
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

  function Controller($root, $timeout, $element, $filter, IrisUtils, Utils) {
    const vm = this;
    vm.$onInit = function () {
      vm.table = $element.find('.table');
      vm.onClick = onClick;
      loadData();
    };

    vm.$onChanges = function () {
      if (!vm.table) {
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

      const dateNumber = IrisUtils.getDateNumber(vm.date);
      const query = `SELECT 
        NON EMPTY {
          [Measures].[TripTime],
          [Measures].[ReferenceTravelTime],
          [Measures].[MeasuredTons],
          [Measures].[CapacityMax],
          [MEMBERDIMENSION].[TimePerformance],
          [ProductionEvent].[H1].[ProductionStatusType].Members
        } ON 0,
        NON EMPTY HEAD(
            NONEMPTYCROSSJOIN(
              [ProductionEventStartTime].[H1].[ProductionEventStartTimeMinute].Members,
              [Trip].[H1].[TripName].Members
            ),
            2000,SAMPLE
          ) ON 1 
          FROM [ASPMINING.ANALYTICS.UNIFIEDEVENTSCUBE] 
          %FILTER NONEMPTYCROSSJOIN(
            [Equipment].[H1].[EquipmentName].&[${vm.truck.name}],
            NONEMPTYCROSSJOIN(
              [EventDateTime].[H1].[EventDateTimeDay].&[${dateNumber}],
              NONEMPTYCROSSJOIN(
                [STATUSEVENT].[H3].[STATUSTYPE].&[Operative],
                %OR({[PRODUCTIONEVENT].[H1].[PRODUCTIONSTATUSTYPE].&[TransitToDumpSite],[PRODUCTIONEVENT].[H1].[PRODUCTIONSTATUSTYPE].&[TransitToLoadSite]})
              )
            )
          )`;

      vm.loading = true;

      IrisUtils
        .executeQuery(query)
        .then(data => {
          console.log(data);
          const rows = data.Cols ? data.Cols[1].tuples : [];
          const cols = data.Cols ? data.Cols[0].tuples : [];

          const date = $filter('date')(vm.date, 'yyyy-MM-dd');
          let chartData = [];
          rows.forEach((current, index) => {
            const minute = new Date(`${date} ${current.caption}:00`);
            const tripName = current.children[0].caption;
            let [origin, destination] = tripName.split(' to ');
            origin = origin || 'Origen desconocido';
            destination = destination || 'Destino desconocido';
            const tripTime = data.Data[index * cols.length];
            const referenceTravelTime = data.Data[index * cols.length + 1] || 0;
            const measuredTons = data.Data[index * cols.length + 2];
            const truckCapacity = data.Data[index * cols.length + 3];
            const timePerformance = data.Data[index * cols.length + 4] || 0;
            const type = data.Data[index * cols.length + 5] ? 'A sitio de descarga' : 'A sitio de carga';

            chartData.push({
              time: minute.getTime(),
              origin: origin,
              destination: destination,
              tripTime: tripTime || 0,
              readableTripTime: Utils.readableTime(tripTime || 0),
              referenceTravelTime: referenceTravelTime,
              readableReferenceTime: Utils.readableTime(referenceTravelTime),
              measuredTons: measuredTons,
              truckCapacity: truckCapacity,
              timePerformance: Math.round(10 * timePerformance) / 10,
              type: type,
              color: getColor(timePerformance)
            });
          });

          vm.loading = false;
          chartData.sort((a, b) => a.time - b.time);

          if (!vm.dtInstance) {
            createTable(chartData);
          } else {
            setTableData(chartData);
          }
        })
        .catch(err => {
          console.log(err);
        });
    }

    function setTableData(data) {
      vm.dtInstance.clear().rows.add(data).draw();
    }

    function createTable(data) {
      vm.dtInstance = vm.table
        .DataTable(Object.assign({
          scrollY: '500px',
          paging: false,
          info: false,
          ordering: false,
          scrollCollapse: true
        }, getColumns(), {data: data}));
    }

    function onClick(trip) {
      vm.selectedTrip = trip;
      $timeout(() => {
        vm.onChartClick({params: trip, from: vm.from, to: vm.to});
      });
    }

    function getColor(value) {
      if (value > 3) {
        return 'gray';
      } else if (value >= .9) {
        return 'green';
      } else if (value >= .5) {
        return 'yellow';
      } else {
        return 'red';
      }
    }

    function getColumns() {
      return {
        columns: [{
          data: 'time',
          title: 'Hora',
          render: (data) => $filter('date')(data, 'HH:mm')
        }, {
          data: 'origin',
          title: 'Origen'
        }, {
          data: 'destination',
          title: 'Destino'
        }, {
          data: 'readableTripTime',
          title: 'Duración'
        }, {
          data: 'timePerformance',
          title: 'Performance',
          render: (value) => (Math.round(value * 1000) / 10) + '%'
        }, {
          data: 'readableReferenceTime',
          title: 'Tiempo de Referencia'
        }, {
          data: 'measuredTons',
          title: 'Toneladas'
        }, {
          data: 'truckCapacity',
          title: 'Capacidad'
        }, {
          data: null,
          title: '',
          className: 'control',
          render: () => '',
          width: '10px'
        }],
        columnDefs: [{
          className: 'none',
          targets: [-2, -3, -4]
        }],
        rowCallback: function (row, data) {
          $('td:nth-child(4)', row).addClass('performance-' + data.color);
          $('td:nth-child(5)', row).addClass('performance-' + data.color);
        },
        responsive: {
          details: {
            type: 'column',
            target: -1
          }
        }
      };
    }
  }
})();