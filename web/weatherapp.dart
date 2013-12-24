import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('weather-app')
class WeatherApp extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  @published String xaxisTitle;
  @published String yaxisTitle;
  
  WeatherApp.created() : super.created() {
  }

  void ready() {
    print(xaxisTitle);
    print(shadowRoot!=null);    
  }
}

