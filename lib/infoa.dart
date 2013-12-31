library infoa;
import 'package:polymer/polymer.dart';
/**
 * A Polymer click counter element.
 */
@CustomTag('info-a')
class InfoA extends PolymerElement {
  @published int count = 0;

  InfoA.created() : super.created() {
  }

}

