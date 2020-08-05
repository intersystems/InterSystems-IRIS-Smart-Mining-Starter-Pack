(() => {
  const angular = window.angular;

  Service.$inject = ['IrisUtils', '$filter', 'Utils'];

  angular
    .module('app')
    .service('LoadDump', Service);

  function Service(IrisUtils, $filter, Utils) {
    return {
      getLoadEvents,
      getDumpEvents,
      getGanttData
    };

    function loadEvent(eventType, trucks, date) {
      const dateNumber = IrisUtils.getDateNumber(date);

      const cols = [
        {dimension: 'Truck', hierarchy: 'H1', hierarchyLevel: 'Name', members: 'Members'}
      ];

      const rowsArrive = [
        {dimension: 'Time', hierarchy: 'H1', hierarchyLevel: 'TimeArriveMinute', members: 'Members'}
      ];

      const hierarchyLevel = eventType === 'LOAD' ? 'TimeFullMinute' : 'TimeDumpMinute';
      const rowsEnd = [
        {dimension: 'Time', hierarchy: 'H2', hierarchyLevel: hierarchyLevel, members: 'Members'}
      ];

      const filters = [
        {dimension: 'Truck', hierarchy: 'H1', hierarchyLevel: 'Name', values: trucks.map(truck => truck.name)},
        {dimension: 'Time', hierarchy: 'H1', hierarchyLevel: 'TIMEARRIVEDAY', values: [dateNumber]}
      ];

      const cubeName = eventType === 'LOAD' ? 'PRODUCTIONLOADEVENTSCUBE' : 'PRODUCTIONDUMPEVENTSCUBE';
      let arriveQuery = IrisUtils.buildQuery(cubeName, cols, rowsArrive, null, filters);
      let endQuery = IrisUtils.buildQuery(cubeName, cols, rowsEnd, null, filters);

      let arriveData = [];
      let endData = [];
      return IrisUtils.executeQuery(arriveQuery)
        .then(data => {
          arriveData = data;
          return IrisUtils.executeQuery(endQuery);
        })
        .then(data => {
          endData = data;
          return {
            start: arriveData,
            finish: endData
          };
        })
        .catch(response => {
          return Promise.reject(Utils.getHTTPError(response));
        });
    }

    function getLoadEvents(trucks, date) {
      return loadEvent('LOAD', trucks, date)
        .catch(err => {
          return Promise.reject(err);
        });
    }

    function getDumpEvents(trucks, date) {
      return loadEvent('DUMP', trucks, date)
        .catch(err => {
          return Promise.reject(err);
        });
    }


    function getGanttData(trucks, date) {
      const result = {
        trucks: trucks.map(current => current.name),
        data: {}
      };

      const names = {
        load: 'Carga',
        transitToDump: 'En transito a Descarga',
        dump: 'Descarga',
        transitToLoad: 'En transito a Carga'
      };

      const rawData = {
        dump: {name: 'Descarga', data: []},
        load: {name: 'Carga', data: []}
      };

      return getLoadEvents(trucks, date)
        .then(data => {
          rawData.load = data;
          return getDumpEvents(trucks, date);
        })
        .then(data => {
          rawData.dump = data;
        })
        .then(() => {
          let temp = {};
          for (let state in rawData) {
            const start = rawData[state].start;
            const finish = rawData[state].finish;

            if (!start.Data || !start.Data.length) {
              continue;
            }

            const trucks = start.Cols[0].tuples.map((current, index) => {
              return {name: current.caption, data: {}, index: index};
            });

            const rowLength = trucks.length;
            const startTimes = getTimes($filter('date')(date, 'dd-MM-yyyy'), start);
            const finishTimes = getTimes($filter('date')(date, 'dd-MM-yyyy'), finish, true);
            let currentIndexes = {};

            trucks.forEach((truck, index) => {
              temp[index] = temp[index] || {};
              temp[index][state] = temp[index][state] || [];
              currentIndexes[index] = getStartIndex(index, start.Data, finish.Data, startTimes, finishTimes, rowLength);
            });

            start.Data.forEach((value, index) => {
              const truckIndex = index % rowLength;

              if (!value || isNaN(currentIndexes[truckIndex])) {
                return;
              }

              const startIndex = Math.floor(index / rowLength);

              const finishIndex = getEndDateIndex(finish, truckIndex, rowLength, currentIndexes[truckIndex]);
              if (finishIndex === -1) {
                return;
              }

              currentIndexes[truckIndex] = finishIndex + 1;

              temp[truckIndex][state].push({
                start: startTimes[startIndex],
                finish: finishTimes[finishIndex],
                type: state
              });
            });
          }

          const filled = generateInBetweenState(temp);

          for (let truckIndex in filled) {
            for (let current of filled[truckIndex]) {
              const type = current.type;
              result.data[type] = result.data[type] || {
                name: names[type],
                data: [],
                dimensions: ['truckIndex', 'start', 'finish']
              };
              result.data[type].data.push([parseInt(truckIndex), current.start, current.finish]);
            }
          }

          return result;
        })
        .catch(err => {
          return Promise.reject(err);
        });
    }

    function getTimes(date, data, fixToEnd) {
      const times = [];
      data.Cols[1].tuples.forEach(current => {
        const hour = current.caption;
        const momentDate = moment(`${date} ${hour}:${fixToEnd ? '59' : '00'}`, 'DD-MM-YYYY HH:mm:ss');
        times.push(momentDate.toDate().getTime());
      });
      return times;
    }

    function getStartIndex(truckIndex, startData, finishData, startTimes, finishTimes, rowLength) {
      let startTimeIndex;

      for (let i = 0; i < startData.length; i = i + rowLength) {
        if (startData[i + truckIndex]) {
          startTimeIndex = Math.floor(i / rowLength);
          break;
        }
      }

      if (isNaN(startTimeIndex)) {
        return;
      }

      let startDate = startTimes[startTimeIndex];

      let finishTimeIndex;
      for (let i = 0; i < finishData.length; i = i + rowLength) {
        let index = Math.floor(i / rowLength);
        const time = finishTimes[index];
        if (finishData[i + truckIndex] && time >= startDate) {
          finishTimeIndex = index;
          break;
        }
      }
      return finishTimeIndex;
    }

    function getEndDateIndex(finish, truckIndex, rowLength, currentIndex) {
      const start = currentIndex * rowLength;
      for (let i = start; i < finish.Data.length; i = i + rowLength) {
        if (finish.Data[i + truckIndex]) {
          return Math.floor(i / rowLength);
        }
      }

      return -1;
    }

    function generateInBetweenState(loadDumpData) {
      const result = {};
      const states = ['load', 'transitToDump', 'dump', 'transitToLoad'];
      for (let truckIndex in loadDumpData) {
        const loadAndDumps = [];
        for (let state in loadDumpData[truckIndex]) {
          Array.prototype.push.apply(loadAndDumps, loadDumpData[truckIndex][state]);
        }

        loadAndDumps.sort((a, b) => a.start === b.start && a.type === 'load' || a.start > b.start ? 1 : -1);
        const filled = [];
        for (let i = 0; i < loadAndDumps.length; i++) {
          const current = loadAndDumps[i];
          const next = loadAndDumps[i + 1];
          if (!next) {
            continue;
          }

          filled.push(current);
          filled.push({
            start: current.finish + 1000,
            finish: next.start - 1000,
            type: states[states.indexOf(current.type) + 1]
          });
        }

        result[truckIndex] = filled;
      }

      return result;
    }
  }
})();