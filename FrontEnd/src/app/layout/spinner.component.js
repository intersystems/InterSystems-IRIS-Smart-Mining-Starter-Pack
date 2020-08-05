;(function () {
  'use strict';
  window.angular
    .module('app')
    .component('spinner', {
      template: `<div class="spinner-container {{ctrl.cssClass}}" ng-hide="!ctrl.show">
          <div class="text-spinner">
            <div class="spinner" ng-class="{'spinner-ready': !ctrl.show}">
              <div class="spinner-bg"></div>
              <div class="spinner-logo" ng-if="ctrl.showLogo"></div>
            </div>
            <div class="spinner-message">
               {{ctrl.text}}
            </div>
          </div>
        </div>`,
      controller: Controller,
      controllerAs: 'ctrl',
      bindings: {
        show: '<',
        text: '<',
        cssClass: '<',
        showLogo: '<?'
      }
    });

  function Controller() {
    const vm = this;

    vm.$onInit = function () {
      vm.showLogo = typeof vm.showLogo === 'boolean' ? vm.showLogo : false;
    };
  }
})();

