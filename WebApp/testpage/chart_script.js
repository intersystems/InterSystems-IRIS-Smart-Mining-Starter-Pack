
function plotChart(chartname, xaxis, yaxis){
  var ctx = document.getElementById(chartname).getContext('2d');
  var chart = new Chart(ctx, {
      // The type of chart we want to create
      type: 'line',
  
      // The data for our dataset
      data: {
          labels: xaxis,
          datasets: [{
              label: 'CA101 - JAN 1 2018',
              backgroundColor: 'rgb(99, 99, 132)',
              borderColor: 'rgb(99, 99, 132)',
              data: yaxis
          }]
      },
  
      // Configuration options go here
      options: {
        scales: {
          yAxes: [{
            ticks: {
                max: 12000,
                min: 0,
                stepSize: 600
            }
          }]
        }
      }
  });
}

function columnsToXAxis(columns){
 /*for(let col in columns){
    let column = columns[col];
    for(let t in column.tuples){
      let tuple = column.tuples[t];
    }
  }*/
  let xaxistuples = columns[1] ? columns[1] : null;

  let xaxis = [];
  if(xaxistuples){
    for(let t in xaxistuples.tuples){
      let caption = xaxistuples.tuples[t].caption;
      xaxis.push(caption);
    }
  }

  return xaxis;
}

function sumData(data){

  let addeddata = [];

  for(let d in data){
    let datapoint = parseInt(data[d]) || 0;
    console.log(datapoint)
    if(d > 0){
      addeddata.push(datapoint + addeddata[d-1]);
    }else{
      addeddata.push(datapoint);
    }
  }
  return addeddata;
}


var mdx = "SELECT NON EMPTY NONEMPTYCROSSJOIN([Truck].[H1].[Name].Members,[Measures].[MeasuredTons]) ON 0,NON EMPTY [TimeEmpty].[H1].[TimeEmpty4].Members ON 1 FROM [PRODUCTIONDUMPEVENTSCUBE] %FILTER %OR({[TRUCK].[H1].[NAME].&[Camion - CA101],[TRUCK].[H1].[NAME].&[Camion - CA102],[TRUCK].[H1].[NAME].&[Camion - CA103]}) %FILTER [TimeEmpty].[H1].[TimeEmpty].&[2018] %FILTER [TimeEmpty].[H1].[TimeEmpty1].&[201801] %FILTER [TimeEmpty].[H1].[TimeEmpty2].&[64649]";
var data = JSON.stringify({"MDX":mdx});

var xhr = new XMLHttpRequest();
xhr.withCredentials = true;

xhr.addEventListener("readystatechange", function() {
  if(this.readyState === 4) {
    //console.log(this.responseText);
    plotChart("myChart", columnsToXAxis(JSON.parse(this.responseText).Cols), sumData(JSON.parse(this.responseText).Data));
  }
});

xhr.open("POST", "http://192.168.0.3:52773/APPINT/MDX?Namespace=APPINT");
xhr.setRequestHeader("Authorization", "Basic U3VwZXJVc2VyOnN5cw==");
xhr.setRequestHeader("Content-Type", "application/json");
//xhr.setRequestHeader("Cookie", "CSPSESSIONID-SP-52773-UP-MDX2JSON-=000000000000FyiBI2AMCAHf0BD_Y5zlp8X$t2gYLiZE_W5r63; CSPWSERVERID=hA0xQYB1");

xhr.send(data);