(() => {
  const angular = window.angular;
  Controller.$inject = ['$element', '$filter', 'IrisUtils', '$translate'];
  angular
    .module('app')
    .component('fleetInformation', {
      templateUrl: 'fleet-information.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller($element, $filter, IrisUtils, $translate) {
    const vm = this;

    vm.$onInit = function () {
      vm.equipmentTable = $element.find('#equipment-table');
      loadData();
    };

    vm.$onDestroy = function () {
      vm.dtInstance.destroy();
    };

    function loadData() {

      let query = `SELECT 
        NON EMPTY {
          [Measures].[Capacity],
          [Measures].[LastActivity]
        } ON 0,
        NON EMPTY HEAD(
          NONEMPTYCROSSJOIN(
            [Equipment].[H1].[EquipmentName].Members,
            NONEMPTYCROSSJOIN(
              [Equipment].[H1].[Model].Members,
              [Equipment].[H1].[Category].Members
            )
          ),2000,SAMPLE) ON 1 
        FROM [ASPMINING.ANALYTICS.EQUIPMENTCUBE] 
        %FILTER %OR({
          [EQUIPMENT].[H1].[CATEGORY].&[Aguateros],
          [EQUIPMENT].[H1].[CATEGORY].&[Aljibe],
          [EQUIPMENT].[H1].[CATEGORY].&[Camion],
          [EQUIPMENT].[H1].[CATEGORY].&[Camiones],
          [EQUIPMENT].[H1].[CATEGORY].&[Carguio],
          [EQUIPMENT].[H1].[CATEGORY].&[Chancado],
          [EQUIPMENT].[H1].[CATEGORY].&[Combus. y Lub.],
          [EQUIPMENT].[H1].[CATEGORY].&[Moto.Niv.],
          [EQUIPMENT].[H1].[CATEGORY].&[Palas],
          [EQUIPMENT].[H1].[CATEGORY].&[Perforadora],
          [EQUIPMENT].[H1].[CATEGORY].&[Retroexcavadora],
          [EQUIPMENT].[H1].[CATEGORY].&[Tow Haul],
          [EQUIPMENT].[H1].[CATEGORY].&[Tractor Neumaticos],
          [EQUIPMENT].[H1].[CATEGORY].&[Tractor Orugas]
        })`;

      vm.loading = true;
      IrisUtils.executeQuery(query)
        .then(result => {
          const rows = result.rows;
          const equipments = [];
          const categories = {};
          rows.forEach(current => {
            const equipment = {name: current.caption, model: null, category: null, lastActivity: '', capacity: ''};
            equipments.push(equipment);
            const model = current.children ? current.children[0] : null;
            if (!model) {
              return;
            }
            equipment.model = model.caption;
            const category = model.children && model.children[0] ? model.children[0].caption : null;
            if (!category) {
              return;
            }
            categories[category] = categories[category] || {name: category, count: 0};
            categories[category].count++;

            equipment.category = category;
          });

          equipments.forEach((equipment, index) => {
            equipment.capacity = result.data[index * 2];
            const lastActivity = result.data[index * 2 + 1];
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
          {title: $translate.instant('components.fleet-information.fleet'), data: 'category'},
          {title: $translate.instant('components.fleet-information.name'), data: 'name'},
          {title: $translate.instant('components.fleet-information.model'), data: 'model', defaultContent: ''},
          {title: $translate.instant('components.fleet-information.tonnage'), data: 'capacity', defaultContent: ''},
          {
            title: $translate.instant('components.fleet-information.lastActivity'),
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