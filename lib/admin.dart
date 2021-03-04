import 'dart:convert';

import 'package:flutter/material.dart';
import 'mqtt_stream.dart';
import 'Mqtt_feed.dart';
import 'main.dart';



class SecondPageDemo extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}





class _SecondPageState extends State<SecondPageDemo> {
  @override
  AppMqttTransactions myMqtt = AppMqttTransactions();

  @override
  void initState() {
    super.initState();
    myMqtt.subscribe("frontend/stations_response");
    print("Nisoşşş");
  }

  _StatusControl2() async  {
    var subscriptionStream;
    subscriptionStream = MqttFeed.subscribeStream.listen((data) {
      print("Gelen istasyon verisi: "+data);
      Map<String, dynamic> map = json.decode(data);
      print("Stations:");
      //if (map["status"]==true)
      //{
      //Navigator.push(context,
      //MaterialPageRoute(builder: (context) => SecondPage()),
      //);
      //}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Page"),
        backgroundColor: Colors.indigo[900],
      ),
      body: Padding(

        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RaisedButton(

              onPressed: () {},
              color: Colors.indigo[900],
              padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 100.0),

              child: Text(
                'İstasyonlar',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            RaisedButton(

              onPressed: () {
                var payload = {};
                payload["request"] = "request";
                _StatusControl2();
                myMqtt.publish("server/stations_request", jsonEncode(payload));
              },
              color: Colors.indigo[900],
              padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 110.0),


              child: Text(
                'İstasyon ekle',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            RaisedButton(

              onPressed: () {},
              color: Colors.indigo[900],
              padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 100.0),


              child: Text(
                'Harita',
                style: TextStyle(fontSize: 40.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 150),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginDemo()));
              },
              color: Colors.indigo[900],
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 110.0),


              child: Text(
                'Çıkış',
                style: TextStyle(fontSize: 40.0, color: Colors.white),
              ),
            ),


          ],
        ),
      ),
    );
  }
}