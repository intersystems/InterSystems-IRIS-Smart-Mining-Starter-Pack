;(function () {
  'use strict';

  const angular = window.angular;

  AppConfig.$inject = ['$locationProvider', '$httpProvider', '$translateProvider', 'LANGS'];

  angular
    .module('app')
    .config(AppConfig);

  function AppConfig($locationProvider, $httpProvider, $translateProvider, LANGS) {
    $locationProvider.html5Mode(true).hashPrefix('#');
    $httpProvider.interceptors.push('IrisInterceptor');

    $translateProvider.useStaticFilesLoader({
      prefix: '/assets/lang/',
      suffix: '.json'
    });

    const currentLang = window.localStorage.getItem('lang');

    if (currentLang && LANGS.indexOf(currentLang) !== -1) {
      $translateProvider.preferredLanguage(currentLang);
    } else {
      $translateProvider.determinePreferredLanguage();
    }

    let lang = $translateProvider.preferredLanguage();
    if (LANGS.indexOf(lang) === -1) {
      lang = lang.substring(0, lang.indexOf('_')).toLowerCase();

      if (LANGS.indexOf(lang) === -1) {
        $translateProvider.fallbackLanguage('en');
      }
    }

    $translateProvider.useSanitizeValueStrategy('escaped');

    const options = {};
    LANGS.forEach(current => options[current + '_*'] = current);

    $translateProvider.registerAvailableLanguageKeys(LANGS, options);
    $translateProvider.useMissingTranslationHandler('TranslateReplacementFactory');
  }
})();
