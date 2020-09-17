(() => {
  Runner.$inject = ['$rootScope', '$transitions', '$state', '$uibModalStack', '$translate', 'LANGS'];

  window.angular
    .module('app')
    .run(Runner);

  function Runner($root, $transitions, $state, $uibModalStack, $translate, LANGS) {
    $root.appReady = false;

    $root.langs = LANGS;
    $root.currentLang = $translate.proposedLanguage();
    $root.currentLang = $root.currentLang ? $root.currentLang.trim() : null;

    $translate
      .onReady()
      .then(function () {
        dataTablesDefault($translate);
        $root.appReady = true;
      });

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

  function dataTablesDefault(translate) {
    translate = translate.instant;
    $.extend(true, $.fn.dataTable.defaults, {
      language: {
        emptyTable: `<div class="alert alert-info no-margin">${translate('datatables.emptyTable')}</div>`,
        zeroRecords: `<div class="alert alert-info no-margin">${translate('datatables.zeroRecords')}</div>`,
        info: translate('datatables.info'),
        infoEmpty: translate('datatables.infoEmpty'),
        infoFiltered: translate('datatables.infoFiltered'),
        lengthMenu: translate('datatables.lengthMenu'),
        loadingRecords: `${translate('datatables.loadingRecords')}`,
        processing: `${translate('datatables.processing')}`,
        search: '',
        searchPlaceholder: translate('datatables.search'),
        paginate: {
          first: translate('datatables.paginate.first'),
          last: translate('datatables.paginate.last'),
          next: translate('datatables.paginate.next'),
          previous: translate('datatables.paginate.previous')
        },
        aria: {
          sortAscending: translate('datatables.aria.sortAscending'),
          sortDescending: translate('datatables.aria.sortDescending')
        }
      }
    });
  }
})();