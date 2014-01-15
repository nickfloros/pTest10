library mfordmap;
import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:google_maps/google_maps.dart';

@CustomTag('mford-map')
class MfordMap extends PolymerElement {

  bool get applyAuthorStyles => true;
  /**
   * center of map latittude ..
   */
  @published num cLat=52.3;
  /*
   * center of map longtude
   */
  @published num cLng=-1.1;

  static final String markerSelectedEvent = "markerSelected";
  
  
  var mapOptions;
  var _mapCanvas;
  GMap _map;
  
  var _latLngBound;
  Map _markers = new Map();

  MfordMap.created() : super.created() {
    print('MfordMap.created : shadowRoot is null ${shadowRoot==null}');
  }

  void enteredView() {
    super.enteredView();
    _init();
  }
  
  /**
   * init map 
   */
  void _init() {
    if (_map==null) {
      _mapCanvas = $['map_canvas'];
      mapOptions = new MapOptions()
      ..zoom = 8
      ..center = new LatLng(cLat,cLng)
      ..mapTypeId = MapTypeId.ROADMAP
      ;

      _map = new GMap(_mapCanvas, mapOptions);

      print('GMap.enteredView : shadowRoot is null ${shadowRoot==null}');
      _latLngBound = new LatLngBounds();
      
    }
  }
  
  void _resize(int width, int height) {
    if (_mapCanvas!=null) {
    _mapCanvas.style.width='${width}px';
    _mapCanvas.style.height='${height}px';
    }
  }
  
  void show(int width,int height) {
    print('resize : [${width},${height}');
    _resize(width,height);
    _map.fitBounds(_latLngBound);
  }
  
  /**
   * add a marker 
   */
  void addMarker(String key, String desc, num lat, num lng){

    
    if(_map!=null) {
      _latLngBound.extend(new LatLng(lat, lng));
      
      var mOptions = new MarkerOptions()
      ..position = new LatLng(lat, lng)
      ..map = _map
      ..title = desc
      ..clickable = true;
      _markers[key]=mOptions;
     MarkerCallback mCallBack = new MarkerCallback(notify,_markers.length-1);
     var m = new Marker(mOptions);
     m.onClick.listen(mCallBack.onClick);
     
    }
    else
      print('Gmap.addMarker _map is null');
  }

  /*
   * fire event identifying that an marker was selected
   */
  void notify(int markerId){
    this.fire(MfordMap.markerSelectedEvent,detail:markerId);
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
