library mford_gae;
import 'dart:html';
import 'dart:async';
import 'dart:convert';

class Mford_Gae_Services {
  var _url = 'https://mford-gae.appspot.com/_ah/api/wsep/v1';
  
  List<Site> sites = new List<Site>();
  
  Mford_Gae_Services(){
    
  }
  
  Future<List<Site>> readSites() {
    Completer comp = new Completer<List<Site>>();
    HttpRequest.getString('$_url/sites')
      .then((result) { 
        comp.complete(_parseSites(result));
        })
      .catchError((onError) {
        comp.completeError('error');
        });

    return comp.future;
  }

  /*
   * parse sites response 
   */
  List<Site> _parseSites(var payload) {
    
    var map = JSON.decode(payload);
    if (map['status']['success'] == true) {
      sites.clear(); // make sure the list of sites is empty
      for (var item in map['sites']) {
        var s = new Site.create(item['id'], 
            item['name'], 
            item['code'],
            item['lattitude'],
            item['longitude']);
        sites.add(s);
      }
    }
    return sites;
  }
  
  /*
   * read site weather info
   */
  Future<List<AnemometerReading>> readSite(int id) {
    
    Completer comp = new Completer<List<AnemometerReading>>();
    
    HttpRequest.getString('$_url/report?site=${sites[id].stationCode}')
      .then((result) { 
        var map = JSON.decode(result);
        List<AnemometerReading> list = new List<AnemometerReading>();
        if (map['status']['success']) {
          for (var reading in map['readings']) {
            list.add(new AnemometerReading.parse(reading));
          }
        }
        comp.complete(list);
        })
      .catchError((onError) {
        comp.completeError('error');
        });

    return comp.future;
  }
}

/*
 * holds anemometer site details
 */
class Site {
  int id;
  
  String stationName;
  String stationCode;
  
  double latitude;
  double longitude;

  Site() {
    
  }
  
  factory Site.create(int id, String name, String code, double latitude, double longitude){
    var value = new Site()
     ..id=id
     ..stationName = name
     ..stationCode = code
     ..latitude = latitude
     ..longitude = longitude;
    
    return value;
  }
}

/**
 * representation of an anemoeter reading 
 */
class AnemometerReading {
  int id;
  DateTime timeStamp;
  WindDirection direction;
  WindSpeed speed;
  
  AnemometerReading() {}

  /**
   * parser 
   */
  factory AnemometerReading.parse(Map jsonMap) {
    var value = new AnemometerReading()
      ..id = jsonMap['id']
      ..timeStamp = DateTime.parse(jsonMap['timeStamp'])
      ..direction = new WindDirection.create(jsonMap['direction'])
      ..speed = new WindSpeed.create(jsonMap['speed']);
    
    return value;
  }
}

class AnemometerReadings {
  List direction=[];
  List speed=[];
  
}
/** 
 * wind direction
 */
class WindDirection {
  
  int min, max, avg;
  
  WindDirection() {
    
  }
  
  factory WindDirection.create(Map jsonMap) {
    var value = new WindDirection()
    ..min = jsonMap['min']
    ..max = jsonMap['max']
    ..avg = jsonMap['avg'];        
    
    return value;
  }
  
  /*
   * map object to list 
   */
  List toList(var xAxisValue) {
    var list= new List()
      ..add(xAxisValue)
      ..add(min)
      ..add(avg)
      ..add(max);
      
    return list;
  }
}

/**
 * wind speed
 */
class WindSpeed {
  double min, max, avg;
  
  WindSpeed() {
    
  }
  
  factory WindSpeed.create(Map jsonMap) {
    var value = new WindSpeed()
      ..min = jsonMap['min']
      ..max = jsonMap['max']
      ..avg = jsonMap['avg'];   
    return value;
  }

  /*
   * map object to a list
   */
  List toList(var xAxisValue) {
    var list= new List()
      ..add(xAxisValue)
      ..add(min)
      ..add(avg)
      ..add(max);
      
    return list;
  }

}