(() => {
  UtilsService.$inject = ['$translate'];

  window.angular
    .module('app')
    .service('Utils', UtilsService);

  function UtilsService($translate) {
    const textTester = document.getElementById('text-tester');

    return {
      getHTTPError,
      getTextWidth,
      readableTime
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

    function readableTime(seconds) {
      let day, format, hour, minute, month, week, year;
      seconds = parseInt(seconds, 10);
      minute = 60;
      hour = minute * 60;
      day = hour * 24;
      week = day * 7;
      year = day * 365;
      month = year / 12;
      format = function (number, key) {
        const string = number === 1
          ? $translate.instant('time.' + key)
          : $translate.instant('time.' + key + 'Pl');
        return number + ' ' + string;
      };
      switch (false) {
        case !(seconds < minute):
          return format(seconds, 'second');
        case !(seconds < hour):
          return format(Math.round(10 * seconds / minute) / 10, 'minute');
        case !(seconds < day):
          return format(Math.round(10 * seconds / hour) / 10, 'hour');
        case !(seconds < week):
          return format(Math.round(10 * seconds / day) / 10, 'day');
        case !(seconds < month):
          return format(Math.round(10 * seconds / week) / 10, 'week');
        case !(seconds < year):
          return format(Math.round(10 * seconds / month) / 10, 'month');
        default:
          return format(Math.round(10 * seconds / year) / 10, 'year');
      }
    }
  }
})();