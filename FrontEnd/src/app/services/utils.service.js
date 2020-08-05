(() => {
  window.angular
    .module('app')
    .service('Utils', UtilsService);

  function UtilsService() {
    const textTester = document.getElementById('text-tester');

    return {
      getHTTPError,
      getTextWidth
    };

    function getHTTPError(response) {
      if (!response) {
        return;
      }
      const error = new Error();
      if (response.data) {
        if (response.data.error) {
          error.message = response.data.error.message;
          error.code = response.data.error.code;
        } else {
          error.message = response.data;
        }
      } else {
        error.message = response.message || 'An unknown error has occurred';
        error.code = response.code || 'UNKNOWN_ERROR';
      }

      if (error.code === 'LOGIN_FAILED') {
        delete response.resource;
      }
      return error;
    }

    function getTextWidth(text, cssClass, style) {
      if (!text) {
        return 0;
      }

      if (cssClass) {
        textTester.classList.add(...cssClass.split(' '));
      }
      if (style && typeof style === 'object') {
        for (let prop in style) {
          textTester.style[prop] = style[prop];
        }
      }

      textTester.textContent = text;
      let width = textTester.offsetWidth;

      textTester.className = '';
      textTester.removeAttribute('style');
      return width;
    }
  }
})();