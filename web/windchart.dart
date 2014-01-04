import 'dart:html';
import 'package:polymer/polymer.dart';
import 'linechart.dart';
import 'package:pTest10/mfordgae.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('wind-chart')
class WindChart extends PolymerElement {

  bool get applyAuthorStyles => true;
  
  LineChart _windSpeedLineChart;
  LineChart _windDirectionLineChart;
  
  WindChart.created() : super.created() {
    if (shadowRoot!=null) {
     _windSpeedLineChart =shadowRoot.querySelector('#speedChart');
     _windDirectionLineChart =shadowRoot.querySelector('#directionChart');
     window.on['drawCharts'].listen( (data) {draw(data.detail);});
    }
  }
  
  void draw(var resp) {
    List directionData = new List() 
      ..add( new List() 
      ..add('Time')
      ..add('Min')
      ..add('Avg')
      ..add('Max')
      );
    
    List speedData = new List() 
      ..add( new List() 
      ..add('Time')
      ..add('Min')
      ..add('Avg')
      ..add('Max')
      );            
      
    for (AnemometerReading item in resp) {
      directionData.add(item.direction.toList(item.timeStamp));
      speedData.add(item.speed.toList(item.timeStamp));
    }
    _windSpeedLineChart.draw(speedData);
    _windDirectionLineChart.draw(directionData);

  }
}