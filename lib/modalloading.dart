library modalloading;
import 'dart:html';
import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('util-modal')
class ModalLoading extends PolymerElement {
  // need that to ensure that bootscrap css is applied
  
  bool get applyAuthorStyles => true;
  
  // list of items to display
  @published 
  String title;

  @published
  String msg;

  @published
  String modalTitle;
  
  ModalLoading.created() : super.created() {
  }

  void enteredView() {
    super.enteredView();
  }
  
  void leftView() {
    super.leftView();
  }
  
  void show() {
    var rootDiv =$['modalLoading']; 
    rootDiv.classes.toggle('in');
    rootDiv.style.display="block";
    rootDiv.attributes['aria-hidden']="false" ;
    
    window.document.getElementsByName('body').first.classes.toggle('modal-open');
        
  }
  
  
  void hide() {
    var rootDiv =$['modalLoading']; 
    rootDiv.classes.toggle('in');
    rootDiv.style.display="none";
    rootDiv.attributes['aria-hidden']="true" ;
    window.document.getElementsByName('body').first.classes.toggle('modal-open');
  }
}

