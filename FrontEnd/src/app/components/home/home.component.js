(() => {
  const angular = window.angular;

  angular
    .module('app')
    .component('home', {
      templateUrl: 'home.template.html',
      controller: HomeController,
      controllerAs: 'ctrl'
    });

  function HomeController() {
    const vm = this;

    vm.$onInit = function () {
    };
  }
})();