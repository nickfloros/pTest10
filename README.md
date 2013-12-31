A test case to understand what happen when using nested components; 2 level only. Shadow dom is enabled.


So pTest10.html instantiates ```<weather-app>``` then ```<weather-app>``` creates two ```<line-charts>``` 
(with id lineA & lineB respectively).

Each ```<line-chart>``` it has id set and two other attributes.

When the application runs on the console you see object id shadowDom!=null
```dart
LineChart.created 	 lineA    false 
LineChart.created 	 lineB 	  false 
LineChart.ready 	 lineA 	  true    
LineChart.created 	 lineA    true  
LineChart.ready 	 lineB    true
LineChart.created 	 lineB    true
WeatherApp.ready   	mainApp   true
LineChart.fromParent lineB              <-- this is invoked from WeatherApp class
LineChart.fromParent lineA
WeatherApp.created  mainApp   true
```
```true``` or ```false``` indicates the result of the shadowDom!=null and getShawdowRoot(component name).

LineChart created & ready are invoked twise. First shadowdom is null and then is true. 

That is rather strange 

