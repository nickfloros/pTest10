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
  static final String selectionEventName='navTabEvent';
  
  static final String mapSelected = 'mapSelected';
  
  // remembers which item is curently selected
  var _currentSelected; 
  
  NavTabs.created() : super.created() {
  }

  void onSelected(Event e, var detail, Element target) {
    var idStr = target.getAttribute('data-value');
    if (idStr!=null) {
      _toggle(target.parent);
      this.fire(selectionEventName,detail:int.parse(idStr));
    }
    
  }
  
  void select(String id){
    var f = document.getElementById(id);

    if (f==null)     // need this for js version ..
      f = shadowRoot.getElementById(id);
    
    if (f!=null) 
      _toggle(f);
  }
  
  void onMapSelected(Event e, var details, Element target) {
    _toggle(target.parent);
    this.fire(mapSelected);
  }
  
  void _toggle(Element target) {
    if (_currentSelected!=null)
      _currentSelected.classes.toggle('active');
    // this is because the action is on the anchor element but the style applies to the parent div
    _currentSelected = target; 
    _currentSelected.classes.toggle('active');
  }
  
  void setSites(var sites){
    options.addAll(sites);
  }
  
  void enteredView() {
    super.enteredView();
    print('navTab enteredView');
  }
  
  /*
   * again hardwired .. 
   */
  int get height {
    return 44;
  }
}

