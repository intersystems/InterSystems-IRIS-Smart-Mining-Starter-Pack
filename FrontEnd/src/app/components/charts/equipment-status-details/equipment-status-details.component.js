;(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$element', 'Equipment', 'Utils'];

  angular
    .module('app')
    .component('equipmentStatusDetailsChart', {
      templateUrl: 'equipment-status-details.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        from: '<',
        to: '<',
        categories: '<',
        equipments: '<',
        status: '<'
      }
    });

  function Controller($root, $element, Equipment, utils) {
    const vm = this;

    let colors = echarts.customColors ? angular.copy(echarts.customColors) : undefined;
    colors = colors ? colors.slice(4) : undefined;

    vm.$onInit = function () {
      const container = $element.find('.bar');
      const pieContainer = $element.find('.pie');
      vm.container = container[0];
      vm.pieContainer = pieContainer[0];
    };

    vm.$onChanges = function () {
      if (!vm.status || (!vm.categories || !vm.categories.length) && (!vm.equipments || !vm.equipments.length)) {
        if (vm.chart) {
          destroyCharts();
        }
        return;
      }
      loadData();
    };

    vm.$onDestroy = function () {
      destroyCharts();
    };

    function destroyCharts() {
      if (vm.chart) {
        echarts.dispose(vm.chart);
      }
      if (vm.pieChart) {
        echarts.dispose(vm.pieChart);
      }
    }

    function loadData() {
      vm.loading = true;
      Equipment
        .statusDetails(vm.from, vm.to, vm.categories, vm.equipments, vm.status)
        .then(data => {
          vm.loading = false;
          plotCharts(data);
        })
        .catch(err => {
          vm.loading = false;
          console.log(err);
        });
    }

    function plotCharts(data) {
      const categoryStep = 5;
      const categories = [];

      for (let i = 0; i < 24 * 60; i += categoryStep) {
        let hour = Math.floor(i / 60);
        let minute = i % 60;

        hour = ('0' + hour).slice(-2);
        minute = ('0' + minute).slice(-2);
        categories.push(`${hour}:${minute}`);
      }

      let series = [];
      data.forEach(current => {
        current.data.map(current => {
          current[1] = Math.round(10 * current[1] / 12) / 10;
          return current;
        });
        series.push({
          name: current.category,
          data: current.data,
          type: 'bar',
          stack: 'stack',
          barWidth: '115%',
          sum: current.data.reduce((sum, current) => current[1] + sum, 0)
        });
      });

      series.sort((a, b) => b.value - a.value);

      const longestSeriesName = series.reduce((result, current) => {
        result.name = current.name.length > result.name.length ? current.name : result.name;
        return result;
      }, {name: ''}).name;

      const paddingRight = Math.ceil(utils.getTextWidth(longestSeriesName, '', {fontSize: '10px'})) + 45;

      const option = {
        color: colors,
        tooltip: {},
        grid: {
          left: 80,
          top: 60,
          right: paddingRight,
          bottom: 60
        },
        yAxis: {
          type: 'value',
          axisLabel: {fontSize: 11},
          name: 'Duración Parcial',
          nameLocation: 'center',
          nameGap: 50,
          nameTextStyle: {
            color: '#333333',
            fontSize: 16
          }
        },
        xAxis: {
          type: 'category',
          data: categories,
          axisLabel: {fontSize: 11},
          name: 'Hora del día',
          nameLocation: 'center',
          nameGap: 30,
          nameTextStyle: {
            color: '#333333',
            fontSize: 16
          }
        },
        series: series,
        legend: {
          type: 'scroll',
          orient: 'vertical',
          right: 0,
          top: 10,
          textStyle: {
            fontSize: 10
          },
          data: series.map(current => current.name)
        }
      };


      vm.chart = resetChart(vm.chart, vm.container, option);

      const pieSeries = {
        type: 'pie',
        name: 'pie',
        radius: '60%',
        label: {
          formatter: '{d}%'
        },
        startAngle: 0,
        data: series.map(current => {
          return {name: current.name, value: Math.round(current.sum * 10) / 10};
        })
      };

      const total = pieSeries.data.reduce((sum, current) => sum + current.value, 0);

      pieSeries.data.forEach(current => {
        current.value = Math.round(10000 * current.value / total) / 100;
      });

      // pieSeries.data.sort((a, b) => b.value - a.value);
      if (pieSeries.data.length >= 15) {
        const data = [];

        pieSeries.data.forEach(current => {
          if (data.length < 15 && current.value >= 1) {
            data.push(current);
          }
        });

        pieSeries.data = data;
        const totalPercent = pieSeries.data.reduce((sum, current) => sum + current.value, 0);
        if (totalPercent < 100) {
          pieSeries.data.push({
            name: 'Otros', value: 100 - totalPercent
          });
        }
      }

      vm.pieChart = resetChart(vm.pieChart, vm.pieContainer, {
        color: colors,
        title: {text: 'Estadística', left: 'center'},
        tooltip: {
          formatter: (params) => {
            return `${params.marker} ${params.data.name}
            <br/>${params.data.value}`;
          }
        },
        legend: {
          orient: 'vertical',
          left: 10,
          type: 'scroll',
          textStyle: {
            fontSize: 10
          }
        },
        series: [pieSeries]
      });
    }


    function resetChart(chart, container, options) {
      if (chart) {
        echarts.dispose(chart);
      }

      if (!chart || chart.isDisposed()) {
        chart = echarts.init(container, 'custom');
      }

      chart.clear();
      chart.setOption(options);
      chart.resize();

      return chart;
    }
  }
})();