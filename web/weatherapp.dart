import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'windchart.dart';
import 'gmap.dart';
import 'package:pTest10/navtabs.dart';
import 'package:pTest10/mfordgae.dart';
import 'footertab.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('weather-app')
class WeatherApp extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  NavTabs _navTab;
  var _wchart;
  var _gMap;
  FooterTab _footerTab;
  int _workAreaHeightOffset=0;
   
  Element _contentDiv;
  
  Mford_Gae_Services _svc;
  
  WeatherApp.created() : super.created() {
    print('WeatherApp.created ${id} ${shadowRoot!=null}');

    if (shadowRoot!=null) { // there is a strange behaviour if element i
      
      // bind to navTabs component
      _navTab = shadowRoot.querySelector('#navTab');
      _footerTab = shadowRoot.querySelector('#footerTab');
      
      window.on[NavTabs.selectionEventName].listen(_showSite);

      window.on[GMap.markerSelectedEvent].listen((eventData) {
        _navTab.select('${eventData.detail}');
        _showSite(eventData);
        });
      
      window.on[NavTabs.mapSelected].listen(_showMap);
      
      _wchart = new Element.tag('wind-chart');
      
      _gMap = new Element.tag('g-map');
      _gMap.resize(window.innerWidth,window.innerHeight-(_navTab.height + _footerTab.height));
      
      _contentDiv = shadowRoot.querySelector('#content')
          ..children.add(_gMap);
      
      _svc=new Mford_Gae_Services()
           ..readSites().then( (resp)=>_renderSites(resp));
      _navTab.select('map');
      window.onResize.listen( (event) {
        print('width : ${window.innerWidth} height: ${window.innerHeight}');
        event.preventDefault(); // stop the event from propagating ..
        if (_showingMap) {
          _gMap.resize(window.innerWidth,window.innerHeight-(_navTab.height + _footerTab.height));
        }
      });
    }
  }

  void enteredView() {
    super.enteredView();
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
  }
  
  /**
   * show data for one of the sites  
   */
  void _showSite(CustomEvent data) {
    if (_contentDiv.children.contains(_gMap)) {
      _contentDiv.children.clear();
      _contentDiv.children.add(_wchart);
    }
    _svc.readSite(data.detail).then( _processResponse);
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

