import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi/wifi.dart' as prefix0;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Globall WiFi Sense',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static double iconsSize = 30.0;   //60 for tablet
  int level = 0;
  List<String> ssidList = [];
  List<Icon> sensorIcons = [
   Icon(Icons.error, color: Colors.red, size: iconsSize,),
   Icon(Icons.error, color: Colors.red, size: iconsSize,),
   Icon(Icons.error, color: Colors.red, size: iconsSize,),
   Icon(Icons.error, color: Colors.red, size: iconsSize,),
   Icon(Icons.error, color: Colors.red, size: iconsSize,),
   Icon(Icons.error, color: Colors.red, size: iconsSize,),
   Icon(Icons.error, color: Colors.red, size: iconsSize,)
  ];
  List<int> signalList = [];
  List<Icon> signalIcons = [
   Icon(CupertinoIcons.battery_empty, color: Colors.red, size: iconsSize,),
   Icon(CupertinoIcons.battery_empty, color: Colors.red, size: iconsSize,),
   Icon(CupertinoIcons.battery_empty, color: Colors.red, size: iconsSize,),
   Icon(CupertinoIcons.battery_empty, color: Colors.red, size: iconsSize,),
   Icon(CupertinoIcons.battery_empty, color: Colors.red, size: iconsSize,),
   Icon(CupertinoIcons.battery_empty, color: Colors.red, size: iconsSize,),
   Icon(CupertinoIcons.battery_empty, color: Colors.red, size: iconsSize,),
  ];
  List<String> sensorNames = [
    "Sensor Porta -1",
    "Sensor Porta 0",
    "Sensor Porta 1",
    "Sensor Porta 2",
    "Sensor Porta 3",
    "Sensor Freio",
    "Emergências"
    ];

  String ssid = '', password = '';

  Timer _everySecond;

  @override
  void initState() {
    super.initState();
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      loadData();
      setState(() {
        for (var i = 0; i < 7; i++) {
          sensorIcons[i] = getImage(i);
          signalIcons[i] = getSignalIcon(i);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Globall WiFi Sense'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: sensorNames.length,
          itemBuilder: (BuildContext context, int index) {
            return itemSSID(index);
          },
        ),
      ),
    );
  }

  Widget itemSSID(index) {
    return Column(children: <Widget>[
      ListTile(
        leading: sensorIcons[index],
        title: Text(
          sensorNames[index],
          style: TextStyle(
            color: Colors.black87,
            fontSize: iconsSize,
          ),
        ),
        trailing: signalIcons[index],
        dense: true,
      ),
      Divider(),
    ]);
  }

  Icon getImage(int index)
  {
    if(ssidList.contains(sensorNames[index])){
      return(
        new Icon(Icons.check_circle, color: Colors.green,size: iconsSize,)
      );    
    }
    else{
      return(
        new Icon(Icons.error, color: Colors.red, size: iconsSize,)
      ); 
    }
  }

  Icon getSignalIcon(int index )
  {
    int strenght = 0;
    if(ssidList.contains(sensorNames[index])){
      strenght = signalList[ssidList.indexOf(sensorNames[index])];
    }
    switch (strenght) {
      case 0:
        return(new Icon(CupertinoIcons.battery_empty));
        break;
      case 1:
        return(new Icon(CupertinoIcons.battery_25_percent));
        break;
      case 2:
        return(new Icon(CupertinoIcons.battery_75_percent));
        break;
      case 3:
        return(new Icon(CupertinoIcons.battery_full));
        break;
      default:
    }
  }

  void loadData() async {
    Wifi.list('').then((list) {
      setState(() {
        ssidList.clear();
        signalList.clear();
        for (var wifi in list) {
          if(wifi.level > 0)
          {
            signalList.add(wifi.level);
            ssidList.add(wifi.ssid);
          }
        }
        list.clear();
      });
    });
  }
}
