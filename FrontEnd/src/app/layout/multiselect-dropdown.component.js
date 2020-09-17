(() => {
  const angular = window.angular;
  Controller.$inject = ['$rootScope'];

  angular
    .module('app')
    .component('multiSelectDropdown', {
      templateUrl: 'multiselect-dropdown.template.html',
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        items: '<',
        selectedItems: '<',
        maxItems: '<',
        onSelect: '&',
        disabled: '<'
      }
    });

  function Controller($root) {
    const vm = this;

    vm.$onInit = function () {
      vm.items = vm.items || [];
      vm.selectedItems = vm.selectedItems || [];
      vm.maxItems = typeof vm.maxItems === 'number' ? vm.maxItems : null;

      vm.toggleItem = toggleItem;
      vm.selectAll = selectAll;
      vm.unSelectAll = unSelectAll;

      vm.isOpened = false;

      vm.onToggle = onToggle;
    };

    vm.$onChanges = function () {
      vm.selectedItems = vm.selectedItems || [];
      vm.selectedItems.forEach(current => {
        current.selected = true;
      });
    };

    function toggleItem(item) {
      const index = vm.selectedItems.findIndex(current => current === item);

      if (index === -1) {
        if (vm.maxItems === null || vm.selectedItems.length < vm.maxItems) {
          vm.selectedItems.push(item);
        }
      } else {
        vm.selectedItems.splice(index, 1);
      }
    }

    function selectAll() {
      vm.selectedItems.splice(0, vm.selectedItems.length);
      for (let item of vm.items) {
        if (item.disabled || vm.maxItems !== null && vm.selectedItems.length >= vm.maxItems) {
          continue;
        }
        item.selected = true;
        vm.selectedItems.push(item);
      }
    }

    function unSelectAll() {
      vm.selectedItems.splice(0, vm.selectedItems.length);
      for (let item of vm.items) {
        item.selected = false;
      }

    }

    function onToggle(open) {
      if (!open) {
        vm.onSelect();
      }
    }
  }
})();