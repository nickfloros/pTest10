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
  @published String cLng='-1.5';

  var _googleMap;
  var mapOptions;
  var _mapCanvas;
  var _map;
  
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
}