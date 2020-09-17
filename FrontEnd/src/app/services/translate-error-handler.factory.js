;(() => {

  window.angular
    .module('app')
    .factory('TranslateReplacementFactory', function () {
      return function (translationID, uses) {
        if (translationID.endsWith('.')) {
          return '';
        }

        const lastDot = translationID.lastIndexOf('.');
        if (lastDot !== -1) {
          translationID = translationID.substring(lastDot + 1);
        }

        return translationID;
      };
    });
})();
