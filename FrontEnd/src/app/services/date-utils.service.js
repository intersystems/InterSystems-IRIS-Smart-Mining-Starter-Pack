;(() => {
  DateUtils.$inject = [];

  angular
    .module('app')
    .service('DateUtils', DateUtils);

  function DateUtils () {

    return {
      pad,
      daysBetween,
      minutesBetween,
      allDaysBetween,
      hoursBetween,
      allHoursBetween
    };

    function daysBetween (date1, date2) {
      return Math.abs(Math.floor((date2.getTime() - date1.getTime()) / (1000 * 3600 * 24)));
    }

    function minutesBetween (date1, date2) {
      return Math.abs(Math.floor((date2.getTime() - date1.getTime()) / (1000 * 60)));
    }

    function allDaysBetween (date1, date2) {
      if (date1 >= date2) {
        return [];
      }

      const days = [];
      for (let date = new Date(date1.getTime()); date <= date2; date.setDate(date.getDate() + 1)) {
        const current = new Date(date.getTime());
        current.setHours(0, 0, 0, 0);
        days.push(current);
      }
      return days;
    }

    function hoursBetween (date1, date2) {
      return Math.abs(Math.floor((date2.getTime() - date1.getTime()) / (1000 * 3600)));
    }

    function allHoursBetween (date1, date2) {
      if (date1 >= date2) {
        return [];
      }

      const hours = [];
      for (let date = new Date(date1.getTime()); date <= date2; date.setHours(date.getHours() + 1)) {
        const current = new Date(date.getTime());
        current.setMinutes(0, 0, 0);
        hours.push(current);
      }
      return hours;
    }

    function pad (number) {
      return ('0' + number).slice(-2);
    }
  }
})();
