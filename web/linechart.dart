import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('line-chart')
class LineChart extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  @published String xaxisTitle;
  @published String yaxisTitle;
  
  LineChart.created() : super.created() {
  }

  void ready() {
    print('LineChart ${id} ${this.getShadowRoot('line-chart')!=null}'); 
    
  }
}
