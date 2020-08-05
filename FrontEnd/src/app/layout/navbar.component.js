;(function () {
  'use strict';

  let angular = window.angular;

  NavBarController.$inject = [
    '$rootScope'
  ];

  angular
    .module('app')
    .component('navBar', {
      templateUrl: 'navbar.template.html',
      controller: NavBarController,
      controllerAs: 'ctrl'
    });

  function NavBarController($rootScope) {
    let vm = this;
    vm.$onInit = function () {
      vm.toggleFullScreen = toggleFullScreen;
    };


    function toggleFullScreen() {
      let element = window.document.documentElement;

      if (!vm.fullScreen) {
        if (element.requestFullscreen) {
          element.requestFullscreen();
        } else if (element.mozRequestFullScreen) {
          element.mozRequestFullScreen();
        } else if (element.webkitRequestFullscreen) {
          element.webkitRequestFullscreen();
        } else if (element.msRequestFullscreen) {
          element.msRequestFullscreen();
        }
      } else {
        if (document.exitFullscreen) {
          document.exitFullscreen();
        } else if (document.mozCancelFullScreen) {
          document.mozCancelFullScreen();
        } else if (document.webkitExitFullscreen) {
          document.webkitExitFullscreen();
        }
      }

      vm.fullScreen = !vm.fullScreen;
    }
  }

})();
