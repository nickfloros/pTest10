import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'jsgmap.dart';
import 'package:pTest10/navbar.dart';
import 'package:pTest10/mfordgae.dart';
import 'footertab.dart';
import 'windchart.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('weather-app')
class WeatherApp extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  NavBar _navTab;
  WindChart _wchart;
  JsGMap _gMap;
  FooterTab _footerTab;
  int _workAreaHeightOffset=0;
  var _contentDiv;
  
  Mford_Gae_Services _svc;
  
  WeatherApp.created() : super.created() {
    print('WeatherApp.created shadowRoot is null ${shadowRoot!=null}');
    _wchart = new Element.tag('wind-chart');
    _gMap = new Element.tag('jsg-map');
   
  }
  
  void enteredView() {
    super.enteredView();
    print('WeatherApp.enteredView shadowRoot is null ${shadowRoot!=null}');
    
    if (shadowRoot!=null) { // there is a strange behaviour 
      
      _navTab = $['navTab'];
      _footerTab = $['footerTab'];

      _contentDiv = $['content']
        ..children.add(_gMap);

      on[NavBar.selectionEventName].listen( (eventData) {
        _showSite(_svc.sites[eventData.detail]);
      });

      on[JsGMap.markerSelectedEvent].listen((eventData) {
        _navTab.select('${eventData.detail}');
        _showSite(_svc.sites[eventData.detail]);
        });
      
      on[NavBar.mapSelected].listen(_showMap);
                  
      _svc=new Mford_Gae_Services()
           ..readSites().then( (resp)=>_renderSites(resp));
//      _navTab.select('map');
      window.onResize.listen( (event) {
        print('width : ${window.innerWidth} height: ${window.innerHeight}');
        event.preventDefault(); // stop the event from propagating ..
        
        if (_showingMap) {
          _gMap.show(window.innerWidth,window.innerHeight-(_navTab.height + _footerTab.height));
        }
        else {
          _wchart.resize(window.innerWidth,window.innerHeight-(_navTab.height + _footerTab.height));
        }
      });
      _gMap.show(window.innerWidth,window.innerHeight-(_navTab.height + _footerTab.height));
    }

  }
  
  /**
   * renders anemometer sites 
   */
  void _renderSites(List<Site> sites){
    _navTab.options.clear();
    for (var item in sites) {
      _navTab.options.add(item.stationName);
      _gMap.addMarker(item.stationCode,item.stationName, item.latitude, item.longitude);
    }
    _gMap.show(window.innerWidth,window.innerHeight-(_navTab.height + _footerTab.height));
  }
  
  /**
   * show data for one of the sites  
   */
  void _showSite(Site data) {
    if (_contentDiv.children.contains(_gMap)) {
      _contentDiv.children.clear();
      _contentDiv.children.add(_wchart);
    }

      _wchart.loading(data.stationName);
    _svc.readSite(data.id).then( _processResponse);
    _wchart.resize(window.innerWidth,window.innerHeight-(_navTab.height + _footerTab.height));
   // _wchart.showBar(data.stationName);    
  }

  /*
   * test to determin if map is on display...
   */
  bool get _showingMap {
    if (_gMap==null) return false;
    return _contentDiv.children.contains(_gMap);
  }

  /**
   * show the map
   */
  void _showMap(CustomEvent data) {
    if (!_contentDiv.children.contains(_gMap)) {
      _contentDiv.children.clear();
      _contentDiv.children.add(_gMap);     
      _gMap.show(window.innerWidth,window.innerHeight-(_navTab.height + _footerTab.height));
      
    }
  }

  void _processResponse(var resp) {
   _wchart.draw(resp);
  }
  
  
}

