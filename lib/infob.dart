library infob;
import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('info-b')
class InfoB extends PolymerElement {
  @published int count = 0;

  InfoB.created() : super.created() {
  }

}

