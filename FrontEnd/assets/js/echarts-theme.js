(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as an anonymous module.
    define(['exports', 'echarts'], factory);
  } else if (typeof exports === 'object' && typeof exports.nodeName !== 'string') {
    // CommonJS
    factory(exports, require('echarts'));
  } else {
    // Browser globals
    factory({}, root.echarts);
  }
}(this, function (exports, echarts) {
  var log = function (msg) {
    if (typeof console !== 'undefined') {
      console && console.error && console.error(msg);
    }
  };
  if (!echarts) {
    log('ECharts is not Loaded');
    return;
  }

  const customColors = echarts.customColors = [
    '#5fe2a0',
    '#a3a1fb',
    '#616dd6',
    '#ffb980',
    '#8d98b3',
    '#56d9fe',
    '#e5cf0d',
    '#97b552',
    '#d87a80',
    '#07a2a4',
    '#9a7fd1',
    '#dc69aa',
    '#588dd5',
    '#f5994e',
    '#c05050',
    '#59678c',
    '#c9ab00',
    '#7eb00a',
    '#6f5553',
    '#c14089'
  ]

  echarts.registerTheme('custom', {
    'color': customColors,
    'backgroundColor': 'rgba(0,0,0,0)',
    'textStyle': {},
    'title': {
      'textStyle': {
        'color': '#222222'
      },
      'subtextStyle': {
        'color': '#555555'
      }
    },
    'line': {
      'itemStyle': {
        'normal': {
          'borderWidth': 1
        }
      },
      'lineStyle': {
        'normal': {
          'width': 2
        }
      },
      'symbolSize': 3,
      'symbol': 'emptyCircle',
      'smooth': true
    },
    'radar': {
      'itemStyle': {
        'normal': {
          'borderWidth': 1
        }
      },
      'lineStyle': {
        'normal': {
          'width': 2
        }
      },
      'symbolSize': 3,
      'symbol': 'emptyCircle',
      'smooth': true
    },
    'bar': {
      'itemStyle': {
        'normal': {
          'barBorderWidth': 0,
          'barBorderColor': '#eaf0f4'
        },
        'emphasis': {
          'barBorderWidth': 0,
          'barBorderColor': '#eaf0f4'
        }
      }
    },
    'pie': {
      'itemStyle': {
        'normal': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        },
        'emphasis': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        }
      }
    },
    'scatter': {
      'itemStyle': {
        'normal': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        },
        'emphasis': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        }
      }
    },
    'boxplot': {
      'itemStyle': {
        'normal': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        },
        'emphasis': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        }
      }
    },
    'parallel': {
      'itemStyle': {
        'normal': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        },
        'emphasis': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        }
      }
    },
    'sankey': {
      'itemStyle': {
        'normal': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        },
        'emphasis': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        }
      }
    },
    'funnel': {
      'itemStyle': {
        'normal': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        },
        'emphasis': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        }
      }
    },
    'gauge': {
      'itemStyle': {
        'normal': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        },
        'emphasis': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        }
      }
    },
    'candlestick': {
      'itemStyle': {
        'normal': {
          'color': '#d87a80',
          'color0': '#2ec7c9',
          'borderColor': '#d87a80',
          'borderColor0': '#2ec7c9',
          'borderWidth': 1
        }
      }
    },
    'graph': {
      'itemStyle': {
        'normal': {
          'borderWidth': 0,
          'borderColor': '#eaf0f4'
        }
      },
      'lineStyle': {
        'normal': {
          'width': 1,
          'color': '#aaa'
        }
      },
      'symbolSize': 3,
      'symbol': 'emptyCircle',
      'smooth': true,
      'color': customColors,
      'label': {
        'normal': {
          'textStyle': {
            'color': '#eaf0f4'
          }
        }
      }
    },
    'map': {
      'itemStyle': {
        'normal': {
          'areaColor': '#dddddd',
          'borderColor': '#eeeeee',
          'borderWidth': 0.5
        },
        'emphasis': {
          'areaColor': 'rgba(254,153,78,1)',
          'borderColor': '#444',
          'borderWidth': 1
        }
      },
      'label': {
        'normal': {
          'textStyle': {
            'color': '#d87a80'
          }
        },
        'emphasis': {
          'textStyle': {
            'color': 'rgb(100,0,0)'
          }
        }
      }
    },
    'geo': {
      'itemStyle': {
        'normal': {
          'areaColor': '#dddddd',
          'borderColor': '#eeeeee',
          'borderWidth': 0.5
        },
        'emphasis': {
          'areaColor': 'rgba(254,153,78,1)',
          'borderColor': '#444',
          'borderWidth': 1
        }
      },
      'label': {
        'normal': {
          'textStyle': {
            'color': '#d87a80'
          }
        },
        'emphasis': {
          'textStyle': {
            'color': 'rgb(100,0,0)'
          }
        }
      }
    },
    'categoryAxis': {
      'axisLine': {
        'show': true,
        'lineStyle': {
          'color': '#eaf0f4'
        }
      },
      'axisTick': {
        'show': true,
        'lineStyle': {
          'color': '#eaf0f4'
        }
      },
      'axisLabel': {
        'show': true,
        'textStyle': {
          'color': '#333333'
        }
      },
      'splitLine': {
        'show': true,
        'lineStyle': {
          'color': [
            '#eaf0f4'
          ]
        }
      },
      'splitArea': {
        'show': false,
        'areaStyle': {
          'color': [
            'rgba(250,250,250,0.3)',
            'rgba(200,200,200,0.3)'
          ]
        }
      }
    },
    'valueAxis': {
      'axisLine': {
        'show': true,
        'lineStyle': {
          'color': '#eaf0f4'
        }
      },
      'axisTick': {
        'show': true,
        'lineStyle': {
          'color': '#eaf0f4'
        }
      },
      'axisLabel': {
        'show': true,
        'textStyle': {
          'color': '#333333'
        }
      },
      'splitLine': {
        'show': true,
        'lineStyle': {
          'color': [
            '#eaf0f4'
          ]
        }
      },
      'splitArea': {
        'show': false,
        'areaStyle': {
          'color': [
            'rgba(250,250,250,0.3)',
            'rgba(200,200,200,0.3)'
          ]
        }
      }
    },
    'logAxis': {
      'axisLine': {
        'show': true,
        'lineStyle': {
          'color': '#eaf0f4'
        }
      },
      'axisTick': {
        'show': true,
        'lineStyle': {
          'color': '#eaf0f4'
        }
      },
      'axisLabel': {
        'show': true,
        'textStyle': {
          'color': '#333333'
        }
      },
      'splitLine': {
        'show': true,
        'lineStyle': {
          'color': [
            '#eee'
          ]
        }
      },
      'splitArea': {
        'show': true,
        'areaStyle': {
          'color': [
            'rgba(250,250,250,0.3)',
            'rgba(200,200,200,0.3)'
          ]
        }
      }
    },
    'timeAxis': {
      'axisLine': {
        'show': true,
        'lineStyle': {
          'color': '#eaf0f4'
        }
      },
      'axisTick': {
        'show': true,
        'lineStyle': {
          'color': '#eaf0f4'
        }
      },
      'axisLabel': {
        'show': true,
        'textStyle': {
          'color': '#333333'
        }
      },
      'splitLine': {
        'show': true,
        'lineStyle': {
          'color': [
            '#eee'
          ]
        }
      },
      'splitArea': {
        'show': false,
        'areaStyle': {
          'color': [
            'rgba(250,250,250,0.3)',
            'rgba(200,200,200,0.3)'
          ]
        }
      }
    },
    'toolbox': {
      'iconStyle': {
        'normal': {
          'borderColor': '#2ec7c9'
        },
        'emphasis': {
          'borderColor': '#18a4a6'
        }
      }
    },
    'legend': {
      'textStyle': {
        'color': '#333333'
      }
    },
    'tooltip': {
      'axisPointer': {
        'lineStyle': {
          'color': '#eaf0f4',
          'width': '1'
        },
        'crossStyle': {
          'color': '#eaf0f4',
          'width': '1'
        }
      }
    },
    'timeline': {
      'lineStyle': {
        'color': '#008acd',
        'width': 1
      },
      'itemStyle': {
        'normal': {
          'color': '#008acd',
          'borderWidth': 1
        },
        'emphasis': {
          'color': '#a9334c'
        }
      },
      'controlStyle': {
        'normal': {
          'color': '#008acd',
          'borderColor': '#008acd',
          'borderWidth': 0.5
        },
        'emphasis': {
          'color': '#008acd',
          'borderColor': '#008acd',
          'borderWidth': 0.5
        }
      },
      'checkpointStyle': {
        'color': '#2ec7c9',
        'borderColor': 'rgba(46,199,201,0.4)'
      },
      'label': {
        'normal': {
          'textStyle': {
            'color': '#008acd'
          }
        },
        'emphasis': {
          'textStyle': {
            'color': '#008acd'
          }
        }
      }
    },
    'visualMap': {
      'color': [
        '#f76565',
        '#fde0e0'
      ]
    },
    'dataZoom': {
      'backgroundColor': 'rgba(47,69,84,0)',
      'dataBackgroundColor': 'rgba(239,239,255,1)',
      'fillerColor': 'rgba(182,162,222,0.2)',
      'handleColor': '#008acd',
      'handleSize': '100%',
      'textStyle': {
        'color': '#333333'
      }
    },
    'markPoint': {
      'label': {
        'normal': {
          'textStyle': {
            'color': '#eaf0f4'
          }
        },
        'emphasis': {
          'textStyle': {
            'color': '#eaf0f4'
          }
        }
      }
    }
  });
}));
