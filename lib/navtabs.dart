library navtabs;
import 'dart:html';
import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('nav-tabs')
class NavTabs extends PolymerElement {
  // need that to ensure that bootscrap css is applied
  bool get applyAuthorStyles => true;
  
  // list of items to display
  @published 
  List options = toObservable([]);

  // event to generate when an option is selected ..
  final String selectionEventName='navTabEvent';
  
  // remembers which item is curently selected
  var _currentSelected; 
  
  NavTabs.created() : super.created() {
    if (shadowRoot!=null) {
      print(selectionEventName);
    }
  }

  void onSelected(Event e, var detail, Element target) {
    var idStr = target.getAttribute('data-value');
    if (idStr!=null) {
      _toggle(target);
      this.fire(selectionEventName,detail:int.parse(idStr));
    }
  }
  
  void _toggle(var target) {
    if (_currentSelected!=null)
      _currentSelected.classes.toggle('active');
    // this is because the action is on the anchor element but the style applies to the parent div
    _currentSelected = target.parent; 
    _currentSelected.classes.toggle('active');
  }
  
  void setSites(var sites){
    options.addAll(sites);
  }
  
}

