import 'package:polymer/polymer.dart';
import 'linechart.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('weather-app')
class WeatherApp extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  LineChart _windSpeedLineChart;
  LineChart _windDirectionLineChart;
  
  WeatherApp.created() : super.created() {
    print('WeatherApp.created ${id} ${shadowRoot!=null}');
    if (shadowRoot!=null) {
      _windSpeedLineChart =shadowRoot.querySelector('#lineA');
      _windDirectionLineChart =shadowRoot.querySelector('#lineB');
    }
  }

  void ready() {
    super.ready();
    print('WeatherApp.ready ${id} ${shadowRoot!=null}');
    _windSpeedLineChart =shadowRoot.querySelector('#lineA');
    _windDirectionLineChart =shadowRoot.querySelector('#lineB');
    _windDirectionLineChart.fromParent();
    _windSpeedLineChart.fromParent();
  }
}

