(() => {

  IrisUtils.$inject = ['$http', 'Utils'];

  window.angular
    .module('app')
    .service('IrisUtils', IrisUtils);

  function IrisUtils($http, utils) {
    const referenceDay = moment(new Date('2018/01/01'));
    const referenceNumber = 64649;

    return {
      getDateNumber,
      getPath,
      buildQuery,
      executeQuery,
      parseTwoDimensionalResponse,
      parseTreeDimensionalResponse
    };

    function executeQuery(query) {
      return $http
        .post(window.IRIS_URL, {'MDX': query})
        .then(response => {
          return response.data;
        })
        .catch(response => {
          return Promise.reject(utils.getHTTPError(response));
        });
    }

    function getDateNumber(date) {
      const momentDate = moment(date);
      return referenceNumber + momentDate.diff(referenceDay, 'days');
    }

    /**
     *
     * @param el
     * @param el.dimension
     * @param el.hierarchy
     * @param el.hierarchyLevel
     * @param el.members
     */
    function getPath(el) {
      return el.path || `[${el.dimension}].[${el.hierarchy}].[${el.hierarchyLevel}].${el.members}`;
    }

    function getFilterPath(filter) {
      let result = '';

      result += filter.values
        .map(value => {
          let valueStr = value;
          if (Array.isArray(value)) {
            valueStr = value.join(']:&[');
          }
          return `[${filter.dimension}].[${filter.hierarchy}].[${filter.hierarchyLevel}].&[${valueStr}]`;
        })
        .join(',');

      if (filter.values.length > 1) {
        result = '%OR({' + result + '})';
      }

      return result;
    }

    function buildQuery(cube, columns, rows, measures, filters) {
      let colString = buildColumns(columns);
      let rowString = buildRows(rows);
      let measureString = buildMeasures(measures);

      let query = 'SELECT';
      if (colString && measureString) {
        query += ` NON EMPTY NONEMPTYCROSSJOIN(${colString}, ${measureString}) ON 0`;
      } else if (colString) {
        query += ` NON EMPTY ${colString} ON 0`;
      } else if (measureString) {
        query += `${measureString} ON 0`;
      }

      if (rowString) {
        query += colString || measureString ? ',' : '';
        query += ` NON EMPTY ${rowString} ON 1`;
      }

      query += ` FROM [${cube}]`;

      if (filters) {
        if (!Array.isArray(filters[0])) {
          filters = [filters];
        }
        filters.forEach(filter => {
          let filterString = buildFilters(filter);
          if (filterString) {
            query += ` %FILTER ${filterString}`;
          }
        });
      }

      // console.log(query);
      return query;
    }

    function buildRows(elements) {
      let result = '';
      if (elements && elements.length) {
        if (elements.length === 1) {
          result = getPath(elements[0]);
        } else {
          result = `{${elements.map(current => getPath(current)).join(',')}}`;
        }
      }

      return result;
    }

    function buildColumns(elements) {
      elements = elements || [];
      let result = '';

      const paths = [];
      elements.forEach(current => {
        let path = getPath(current);
        if (current.children) {
          let children = current.children.map((child) => getPath(child)).join(',');
          if (current.children.length > 1) {
            children = '{' + children + '}';
          }

          path = 'NONEMPTYCROSSJOIN(' + path + ',' + children + ')';
        }
        paths.push(path);
      });

      result = paths.join(',');

      if (elements.length > 1) {
        result = '{' + result + '}';
      }

      return result;
    }

    function buildFilters(filters) {
      let result = '';
      if (!filters) {
        return '';
      }
      // Remove empty filters
      filters = filters.filter(filter => filter.values && filter.values.length);

      if (filters.length) {
        for (let i = filters.length - 1; i >= 0; i--) {
          const filter = filters[i];
          if (i === filters.length - 1) {
            result = getFilterPath(filter);
            continue;
          }

          result = `NONEMPTYCROSSJOIN(${getFilterPath(filter)},${result})`;
        }
      }

      return result;
    }

    function buildMeasures(measures) {
      if (!measures || !measures.length) {
        return '';
      }

      const measureString = typeof measures === 'string'
        ? `[Measures].[${measures}]`
        : measures.map(current => `[Measures].[${current}]`).join(',');

      return '{' + measureString + '}';
    }


    function parseTwoDimensionalResponse(response, byRow) {
      const result = [];
      let columns = byRow ? response.Cols[1].tuples : response.Cols[0].tuples;
      let rows = byRow ? response.Cols[0].tuples : response.Cols[1].tuples;
      const data = response.Data;
      const columnsLength = byRow ? rows.length : columns.length;

      for (let i = 0; i < columns.length; i++) {
        const column = columns[i].caption;
        const columnData = [];
        for (let j = 0; j < rows.length; j++) {
          const row = rows[j].caption;

          const rowIndex = byRow ? i : j;
          const columnIndex = byRow ? j : i;
          const value = data[columnsLength * rowIndex + columnIndex] || 0;
          columnData.push([row, value]);
        }

        result.push({category: column, data: columnData});
      }


      return result;
    }

    function parseTreeDimensionalResponse(response, byRow) {
      const result = [];
      let columns = byRow ? response.Cols[1].tuples : response.Cols[0].tuples;
      let rows = byRow ? response.Cols[0].tuples : response.Cols[1].tuples;
      const data = response.Data;

      columns = columns.reduce((array, current) => {
        current.children = current.children || [];
        current.children.forEach(child => {
          child.parent = current.caption;
          array.push(child);
        });
        return array;
      }, []);

      const columnsLength = byRow ? rows.length : columns.length;

      for (let i = 0; i < columns.length; i++) {
        const column = columns[i].caption;
        const columnData = [];
        for (let j = 0; j < rows.length; j++) {
          const row = rows[j].caption;

          const rowIndex = byRow ? i : j;
          const columnIndex = byRow ? j : i;
          const value = data[columnsLength * rowIndex + columnIndex] || 0;
          columnData.push([row, value]);
        }

        result.push({category: column, parent: columns[i].parent, data: columnData});
      }


      return result;
    }
  }
})();