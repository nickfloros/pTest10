import 'dart:html';

import 'package:polymer/polymer.dart';
import 'linechart.dart';
import 'package:pTest10/mfordgae.dart';
import 'package:pTest10/modalloading.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('wind-chart')
class WindChart extends PolymerElement {

  bool get applyAuthorStyles => true;
  
  @observable
  String siteName;
  
  LineChart _windSpeedLineChart;
  LineChart _windDirectionLineChart;
  ModalLoading _progressBar;
  WindChart.created() : super.created() {
    print('WindChart.created : shadowRoot is null ${shadowRoot==null}');
  }

  void enteredView() {
    super.enteredView();
    print('WindChart.enteredView : shadowRoot is null ${shadowRoot==null}');
    if (shadowRoot!=null) {      
     _windSpeedLineChart =$['speedChart'];
     _windDirectionLineChart =$['directionChart'];
     _progressBar = $['modalLoading'];
     // look for component rather than id ... 
     // _progressBar = this.shadowRoot.getElementsByTagName('yab-progress-bar').first;
     window.on['drawCharts'].listen( (data) {draw(data.detail);});
    }
  }
  
  void resize(int width, int height) {
    $['chartDiv'].style.width='${width}px';
    $['chartDiv'].style.height='${height}px';
  }
  
  void loading(String name) {
    print('Loading - $name');
    siteName = name;
    _progressBar.show();
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
    _progressBar.hide(); 
  }
}
