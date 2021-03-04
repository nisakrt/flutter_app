import 'dart:convert';

import 'package:flutter/material.dart';
import 'mqtt_stream.dart';
import 'Mqtt_feed.dart';
import 'login.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}


class LoginDemo extends StatefulWidget {
  @override

  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  @override
  AppMqttTransactions myMqtt = AppMqttTransactions();

  @override
  void initState()
  {
    super.initState();
    myMqtt.subscribe("frontend/response");
    _StatusControl();
  }

  final username_Controller = TextEditingController();
  final password_Controller = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    username_Controller.dispose();
    super.dispose();
  }

  @override
  void dispose1() {
    // Clean up the controller when the widget is disposed.
    password_Controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),

              child: TextField(
                controller: username_Controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                controller: password_Controller,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            FlatButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.indigo[900], fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.indigo[900], borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  var payload = {};
                  payload["username"] = username_Controller.text;
                  payload["password"] = password_Controller.text;
                  myMqtt.publish("server/login" ,jsonEncode(payload));

                },
                splashColor: Colors.indigo,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),

            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }

  _StatusControl() async  {
    MqttFeed.subscribeStream.listen((data) {
      print("Gelen veri: "+data);
      Map<String, dynamic> map = json.decode(data);
      if (map["status"]==true)
      {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => SecondPage()),
        );
      }
    });
  }
  HomePage() {}
}
class SecondPage extends StatelessWidget {
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
          children:<Widget>[
            RaisedButton(

              onPressed: (){},
              color:Colors.indigo[900],
              padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 100.0),

              child: Text(
                'İstasyonlar',
                style: TextStyle(fontSize:20.0,color:Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            RaisedButton(

              onPressed: (){},
              color:Colors.indigo[900],
              padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 110.0),


              child: Text(
                'İstasyon ekle',
                style: TextStyle(fontSize:20.0,color:Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            RaisedButton(

              onPressed: (){},
              color:Colors.indigo[900],
              padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 100.0),


              child: Text(
                'Harita',
                style: TextStyle(fontSize:40.0,color:Colors.white),
              ),
            ),
            const SizedBox(height: 150),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LoginDemo()));
              },
              color:Colors.indigo[900],
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 110.0),




              child: Text(
                'Çıkış',
                style: TextStyle(fontSize:40.0,color:Colors.white),
              ),
            ),


          ],
        ),
      ),
    );
  }
}