library linechart;
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'dart:js' show context, JsObject, JsFunction;

import 'package:pTest10/chart_elements.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('line-chart')
class LineChart extends PolymerElement {
  
  bool get applyAuthorStyles => true;

  /*
   * chart title
   */
  @published String chartTitle;
  /**
   * x axis title
   */
  @published String xaxisTitle;
  /*
   * y axis title
   */
  @published String yaxisTitle;
  /*
   * min y value
   */
  @published String minValue;
  /*
   * max y value; settable from 
   */
  @published String maxValue;
  
  InfoA _infoa;
  var _gvis;
  var _chartDiv;
  var _chartOptions;
  var _chartData;
  var _lineChart;
  
  Completer _loadCompleter;
  
  LineChart.created() : super.created() {
    print('LineChart.created shadowRoot is null ${shadowRoot==null}');
    if (shadowRoot!=null) {
      _load().then((_) {_intChart();});
    }
  }
  
  Future _load() {
    _loadCompleter = new Completer();
    context["google"].callMethod('load',
       ['visualization', '1', new JsObject.jsify({
         'packages': ['corechart'],
         'callback': new JsFunction.withThis(_loadCompleter.complete)
       })]);
    return _loadCompleter.future;
  }

  
  void _intChart() {
    
    var options={
      'title': chartTitle,
      'hAxis': {'title': xaxisTitle,'format':'HH:mm'},
      'vAxis': {'title': yaxisTitle}
    };
    if (minValue!=null) {
      var f1 = options['vAxis'];
      f1.addAll({'viewWindowMode':'explicit','viewWindow':{'min': int.parse(minValue), 'max': int.parse(maxValue)}});
    }
    
    // where we will display the chart
    _chartDiv = shadowRoot.querySelector('#chart');
    // google visualization library ref
    _gvis = context["google"]["visualization"];
    // set chart options ..
    _chartOptions = new JsObject.jsify(options);
    // and finally line chart object
    _lineChart = new JsObject(_gvis["LineChart"], [_chartDiv]);
    
  }

  /**
   * draws a line chart. The data need to be in the following format {[x, y1, y2, y3]}
   */
  void draw(List data){
    _chartData = _gvis.callMethod('arrayToDataTable', [new JsObject.jsify(data)]);
    _lineChart.callMethod('draw', [_chartData, _chartOptions]);
  }
  
}
