library jsgmap;
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:js' show context, JsObject, JsFunction;

@CustomTag('jsg-map')
class JsGMap extends PolymerElement {

  bool get applyAuthorStyles => true;
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
  JsObject _center;
  var _latLngBound;
  Map _markers = new Map();

  JsGMap.created() : super.created() {
    print('GMap.created : shadowRoot is null ${shadowRoot==null}');
    _init();
  }

  void enteredView() {
    super.enteredView();
    print('GMap.enteredView : shadowRoot is null ${shadowRoot==null}');
    _init();
  }
  
  /**
   * init map 
   */
  void _init() {
    if (_mapCanvas==null) {
      _mapCanvas = shadowRoot.querySelector('#map_canvas');
      _googleMap = context['google']['maps'];
      _center = new JsObject(_googleMap['LatLng'], [num.parse(cLat),num.parse(cLng)]);
     
      var mapTypeId = _googleMap['MapTypeId']['ROADMAP'];
      mapOptions = new JsObject.jsify({
        "center": _center,
        "zoom": 8,
        "mapTypeId": mapTypeId
      });

      _latLngBound = new JsObject(_googleMap['LatLngBounds'],[]);
      _map = new JsObject(_googleMap['Map'], [_mapCanvas, mapOptions]);    
    }
  }
  
  void _resize(int width, int height) {
    if (_mapCanvas!=null) {
    _mapCanvas.style.width='${width}px';
    _mapCanvas.style.height='${height}px';
    }
  }
  
  void show(int width,int height) {
    this.focus(); // grap focus ..
    _resize(width,height);
    new JsObject(_googleMap['event']['trigger'],[_map,'resize']);
    _map.callMethod('fitBounds',[_latLngBound]);    
  }
  
  /**
   * add a marker 
   */
  void addMarker(String key, String desc, num lat, num lng){
    
    
    _latLngBound.callMethod('extend',[new JsObject(_googleMap['LatLng'], [lat,lng])]);
    
    if(_map!=null) {
    
    var markerOptions = new JsObject.jsify({
      "position":new JsObject(_googleMap['LatLng'], [lat,lng]),
      "map":_map,
      "title": desc
    });
    
    

    _markers[key] = new JsObject(_googleMap['Marker'],[markerOptions]);
    _googleMap['event'].callMethod('addListener',
                                  [_markers[key],'click',
                                   new MarkerCallback(notify,_markers.length-1).onClick]);
    }
    else
      print('Gmap.addMarker _map is null');
  }

  /*
   * fire event identifying that an marker was selected
   */
  void notify(int markerId){
    this.fire(JsGMap.markerSelectedEvent,detail:markerId);
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
