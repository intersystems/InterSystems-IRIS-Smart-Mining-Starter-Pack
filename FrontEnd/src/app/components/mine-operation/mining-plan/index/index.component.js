(() => {
  const angular = window.angular;

  Controller.$inject = ['$element', '$filter', 'IrisUtils'];

  angular
    .module('app')
    .component('miningPlanIndex', {
      templateUrl: 'index.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller($element, $filter, IrisUtils) {
    const vm = this;

    vm.$onInit = function () {
      vm.equipmentTable = $element.find('#equipment-table');
      loadData();
    };

    vm.$onDestroy = function () {
      vm.dtInstance.destroy();
    };

    function loadData() {
      let query = `SELECT NON EMPTY {
        [Measures].[Capacity],
        [Measures].[LastActivity]
      } ON 0,
      NON EMPTY HEAD(
        NONEMPTYCROSSJOIN(
          [Equipment].[H1].[EquipmentName].Members,
          NONEMPTYCROSSJOIN(
            [Equipment].[H1].[CategoryName].Members,
            [Model].[H1].[Model].Members)
          )
        ,2000,SAMPLE) ON 1 
      FROM [ASPMINING.ANALYTICS.EQUIPMENTCUBE]
      %FILTER (
        [EQUIPMENT].[H1].[CATEGORYNAME].&[0].%NOT,
        [EQUIPMENT].[H1].[CATEGORYNAME].&[13].%NOT,
        [EQUIPMENT].[H1].[CATEGORYNAME].&[47].%NOT,
        [EQUIPMENT].[H1].[CATEGORYNAME].&[50].%NOT,
        [EQUIPMENT].[H1].[CATEGORYNAME].&[53].%NOT,
        [EQUIPMENT].[H1].[CATEGORYNAME].&[62].%NOT,
        [EQUIPMENT].[H1].[CATEGORYNAME].&[67].%NOT,
        [EQUIPMENT].[H1].[CATEGORYNAME].&[69].%NOT,
        [EQUIPMENT].[H1].[CATEGORYNAME].&[70].%NOT
        )`;

      vm.loading = true;
      IrisUtils.executeQuery(query)
        .then(data => {
          const Cols = data.Cols || [];
          const cols = Cols[1] && Cols[1].tuples ? Cols[1].tuples : [];
          const equipments = [];
          const categories = {};
          cols.forEach(current => {
            const equipment = {name: current.caption, model: null, category: null, lastActivity: '', capacity: ''};
            equipments.push(equipment);
            const category = current.children ? current.children[0] : null;
            if (!category) {
              categories['Indefinida'] = categories['Indefinida'] || {name: 'Indefinida', count: 0};
              categories['Indefinida'].count++;
              return;
            }

            categories[category.caption] = categories[category.caption] || {name: category.caption, count: 0};
            categories[category.caption].count++;

            equipment.category = category.caption;
            equipment.model = category.children && category.children[0] ? category.children[0].caption : null;
          });

          equipments.forEach((equipment, index) => {
            equipment.capacity = data.Data[index * 2];
            const lastActivity = data.Data[index * 2 + 1];
            equipment.lastActivity = !isNaN(parseFloat(lastActivity)) ? IrisUtils.getDateFromNumber(lastActivity) : null;
          });

          vm.equipments = equipments;
          vm.categories = Object.values(categories);
          createEquipmentTable(vm.equipmentTable, equipments);
          vm.loading = false;
        })
        .catch(err => {
          console.log(err);
          vm.loading = false;
        });
    }

    function createEquipmentTable(table, equipments) {
      vm.dtInstance = table.DataTable({
        data: equipments,
        searching: false,
        paging: false,
        lengthChange: false,
        scrollY: 600,
        destroy: true,
        order: [],
        columnDefs: [
          {targets: '_all', searchable: false}
        ],
        columns: [
          {title: 'Flota', data: 'category'},
          {title: 'Nombre', data: 'name'},
          {title: 'Modelo', data: 'model', defaultContent: ''},
          {title: 'Tonelaje', data: 'capacity', defaultContent: ''},
          {
            title: 'Última actividad',
            data: 'lastActivity',
            render: (value) => {
              return value ? $filter('date')(value, 'dd-MM-yyyy') : '';
            }
          }
        ]
      });
    }
  }
})();