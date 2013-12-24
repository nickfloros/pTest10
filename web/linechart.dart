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
    print('LineChart.created ${id} ${this.getShadowRoot('line-chart')!=null}');
  }

  void ready() {
    super.ready();
    print('LineChart.ready ${id} ${this.getShadowRoot('line-chart')!=null}'); 
  }
  
  void fromParent() {
    print('LineChart.fromParent ${id}');
  }
}
