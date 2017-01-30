'use strict';

var margin = {top: 40, right: 40, bottom: 40, left: 160},
    width = 1600 - margin.left - margin.right,
    height = 800 - margin.top - margin.bottom;

var x = d3.scale.linear()
    .range([0, width]);
var r = d3.scale.sqrt()
    .range([1, 12]);
var o = d3.scale.pow().exponent(2)
    .range([0, 1]);
var hue = d3.scale.log()
    .range([0, 240]);
var luminosity = d3.scale.log()
    .range([1, 0]);
var y = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom")
    .tickFormat(function(d) { return (new Date(d)).toISOString(); });

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");

function visie (data) {

  function pluck(key) {
    return function(d) {
      return d[key];
    };
  }
  var getDate = function(d) { return new Date(pluck('date')(d)); };
  var getValue = pluck('value');
  var getSize = pluck('size');

  var flattened = data.reduce(function(prev, curr) {
    return prev.concat(curr.averages);
  }, []);
  var autoScaleY = true;
  if (autoScaleY) {
    y.domain(d3.extent(flattened, getValue));
  } else {
    y.domain([-250, 0]);
  }
  r.domain(d3.extent(flattened, getSize));
  hue.domain(d3.extent(flattened, getSize));
  luminosity.domain(d3.extent(flattened, getSize));
  o.domain(d3.extent(flattened, getSize));
  x.domain(d3.extent(data, getDate));

  var svg = d3.select("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("Date")

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);

  var collection = svg.selectAll("g.collection")
      .data(data)
      .enter().append("g")
      .attr("class", "collection")
      .attr("transform", function(d) {
        return "translate("+x(getDate(d))+", 0)";
      });

  collection
    .selectAll("circle.average")
    .data(function(d) {
      var a = d.averages;
      a.reverse();
      return a;
    })
    .enter().append("circle")
    .attr("class", "average")
    .attr("cy", function(a) {
      return y(getValue(a));
    })
    .attr("cx", "0")
    .attr("r", function(a) {
      return r(getSize(a));
    })
    .attr("style", function(a) {
      var opa = o(getSize(a));
      var useLuminosity = true;
      if (useLuminosity) {
        var col = d3.hsl(220, 1, luminosity(getSize(a)));
      } else {
        var col = d3.hsl(hue(getSize(a)), 1, 0.5);
      }
      return "opacity: "+opa+"; fill: "+col+";";
    });
  
}
