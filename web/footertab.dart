library infob;
import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('footer-tab')
class FooterTab extends PolymerElement {
  // need that to ensure that bootscrap css is applied
  bool get applyAuthorStyles => true;

  FooterTab.created() : super.created() {
  }

  
  void enteredView() {
    super.enteredView();
  }
  
  int get height {
    return 52;
  }
}

