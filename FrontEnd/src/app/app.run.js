(() => {
  Runner.$inject = ['$rootScope', '$transitions', '$state', '$uibModalStack', 'IrisUtils'];

  window.angular
    .module('app')
    .run(Runner);

  function Runner($root, $transitions, $state, $uibModalStack, IrisUtils) {
    $root.appReady = true;

    $transitions.onBefore({}, transition => {
      let next = transition.$to().self;
      let loginState = $state.target('public.login');
      let member = $state.target('member.home');

      if (next.login) {
      } else if (next.authenticated) {
      }

      return Promise.resolve();
    });

    $transitions.onError({}, transition => {
      let error = transition.error();
      if (error) {
        if (error.type === 5) { // The transition was ignored
          $root.viewLoading = false;
        }

        if (error.detail) {
          if (error.detail.redirectTo) {
            $state.go(error.detail.redirectTo, error.detail.params);
          } else if (error.detail.status === 401) {
            $state.go('public.login');
          } else if (error.type !== 2) {
            console.log(error);
            $state.go('member.home');
          }
        }
      }
    });

    $transitions.onStart({}, transition => {
      $uibModalStack.dismissAll();
      $root.viewLoading = true;
    });

    $transitions.onFinish({}, transition => {
      $root.viewLoading = false;
    });
  }
})();