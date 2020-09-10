window.IRIS_URL = 'http://gw.xompass.com:52773/MDX2JSON/MDX?Namespace=APPINT';

$.extend(true, $.fn.dataTable.defaults, {
  language: {
    emptyTable: `<div class="alert alert-info no-margin">No se han encontrado elementos</div>`,
    zeroRecords: `<div class="alert alert-info no-margin">No se han encontrado elementos</div>`,
    info: 'Mostrando _START_ al _END_ de un total de _TOTAL_ elementos',
    infoEmpty: 'Mostrando 0 al 0 de un total de 0 elementos',
    infoFiltered: '(filtrado de un total de _MAX_ elementos)',
    lengthMenu: 'Mostrar _MENU_ elementos',
    loadingRecords: 'Cargando...',
    processing: 'Procesando...',
    search: '',
    searchPlaceholder: 'Buscar',
    paginate: {
      first: 'Primero',
      last: 'Último',
      next: 'Siguiente',
      previous: 'Previo'
    },
    aria: {
      sortAscending: ': activar para ordenar la columna de manera ascendente',
      sortDescending: ': activar para ordenar la columna de manera descendente'
    }
  }
});

;(() => {
  'use strict';

  window.angular
    .module('app', [
      'ngSanitize',
      'angular-storage',
      'ui.router',
      'ui.select',
      'ui.bootstrap',
      'ui.bootstrap.datetimepicker'
    ]);
})();
