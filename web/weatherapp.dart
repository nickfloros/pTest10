import 'dart:html';
import 'package:polymer/polymer.dart';
import 'linechart.dart';
import 'package:pTest10/navtabs.dart';
import 'package:pTest10/mfordgae.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('weather-app')
class WeatherApp extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  NavTabs _navTab;
  LineChart _windSpeedLineChart;
  LineChart _windDirectionLineChart;

  Mford_Gae_Services _svc;
  
  WeatherApp.created() : super.created() {
    print('WeatherApp.created ${id} ${shadowRoot!=null}');

    if (shadowRoot!=null) { // there is a strange behaviour if element i

      // bind to navTabs component
      _navTab = shadowRoot.querySelector('#navTab');
      window.on[_navTab.selectionEventName].listen(_showSite);
      
      _windSpeedLineChart =shadowRoot.querySelector('#speedChart');
      _windDirectionLineChart =shadowRoot.querySelector('#directionChart');
      
      _svc=new Mford_Gae_Services()
           ..readSites().then( (resp)=>_renderSites(resp));
      
    }
  }

  void _renderSites(List<Site> sites){
    _navTab.options.clear();
    for (var item in sites) {
      _navTab.options.add(item.stationName);
    }
  }
  
  void _showSite(CustomEvent data) {
    _svc.readSite(data.detail).then( _processResponse);
  }
  
  void _processResponse(var resp) {
    // set headers ... 
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

