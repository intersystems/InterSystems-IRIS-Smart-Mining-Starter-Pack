(() => {
  const angular = window.angular;

  Controller.$inject = ['$rootScope', '$timeout', '$element', '$compile', '$transitions', '$state'];

  angular
    .module('app')
    .component('production', {
      templateUrl: 'production.template.html',
      controller: Controller,
      controllerAs: 'ctrl'
    });

  function Controller($root, $timeout, $element, $compile, $transitions, $state) {
    const vm = this;

    vm.$onInit = function () {
    };

    vm.$onDestroy = function () {

    };

  }
})();