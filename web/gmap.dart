import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:js' show context, JsObject, JsFunction;

@CustomTag('g-map')
class GMap extends PolymerElement {

  /**
   * center of map latittude ..
   */
  @published String cLat='52.3';
  /*
   * center of map longtude
   */
  @published String cLng='-1.2';

  static final String markerSelectedEvent = "markerSelected";
  
  var _googleMap;
  var mapOptions;
  var _mapCanvas;
  var _map;

  JsObject _latLngBound;
  Map _markers = new Map();

  GMap.created() : super.created() {
    if (shadowRoot!=null) {
      _init();
    }
  }
  
  /**
   * init map 
   */
  void _init() {
    _mapCanvas = shadowRoot.querySelector('#map_canvas');
    
    _googleMap = context['google']['maps'];
    var center = new JsObject(_googleMap['LatLng'], [num.parse(cLat),num.parse(cLng)]);

    var mapTypeId = _googleMap['MapTypeId']['ROADMAP'];
    mapOptions = new JsObject.jsify({
      "center": center,
      "zoom": 8,
      "mapTypeId": mapTypeId
    });
    
    _map = new JsObject(_googleMap['Map'], [_mapCanvas, mapOptions]);    
  }
  
  void resize(int width, int height) {
    _mapCanvas.style.width='${width}px';
    _mapCanvas.style.height='${height}px';
  }
  
  void show(int width,int height) {
    resize(width,height);
    new JsObject(_googleMap['event']['trigger'],[_map,'resize']);
  }
  
  /**
   * add a marker 
   */
  void addMarker(String key, String desc, num lat, num lng){
    var point =  new JsObject(_googleMap['LatLng'], [lat,lng]);
    
    if (_latLngBound==null) {
      _latLngBound = new JsObject(_googleMap['LatLngBounds'],[]);
    }
    _latLngBound.callMethod('extend',[point]);
    
    var markerOptions = new JsObject.jsify({
      "position":point,
      "map":_map,
      "title": desc
    });
    
    _map.callMethod('fitBounds',[_latLngBound]);

    _markers[key] = new JsObject(_googleMap['Marker'],[markerOptions]);
    _googleMap['event'].callMethod('addListener',
                                  [_markers[key],'click',
                                   new MarkerCallback(notify,_markers.length-1).onClick]);

    
  }

  /*
   * fire event identifying that an marker was selected
   */
  void notify(int markerId){
    this.fire(GMap.markerSelectedEvent,detail:markerId);
  }
  
}

/**
 * temp class to hold marker referrence ... this is too convoluted there should be a better way 
 */
class MarkerCallback {
  int ref;
  var _callBack;
  MarkerCallback(Function win,int k) {
    _callBack = win;
    ref=k;
  }
  
  /*
   * call back from JS universe
   */
  void onClick(var misc) {
    print('selected ${ref}');
    _callBack(ref);
  }
}
