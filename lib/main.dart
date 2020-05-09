import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:task/second.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Connectivity _connectivity =new Connectivity();
  StreamSubscription<ConnectivityResult> subscription;
  bool _connected;

  @override
  void initState() {
    super.initState();

    subscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.toString());
      if (result == ConnectivityResult.mobile) {
        print("Connected to Mobile Network");
       setState(() {
         _connected=true;
       });

      } else if (result == ConnectivityResult.wifi) {
        print("Connected to WiFi");
        setState(() {
          _connected=true;
        });
      } else {
        setState(() {
          _connected=false;
        });
      }
    });
  }

 @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  final String apiUrl = "https://randomuser.me/api/?results=10";

  Future<List<dynamic>> People() async {

    var result = await http.get(apiUrl);
    return json.decode(result.body)['results'];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _connected!=null?_connected?FutureBuilder<List<dynamic>>(
          future: People(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return
                      Card(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Second(snapshot.data[index]['name']['title'])),
                                );
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(snapshot.data[index]['picture']['large'])),
                                title: Text(snapshot.data[index]['name']['title']),
                                subtitle: Text(snapshot.data[index]['dob']['age'].toString()),
                              ),
                            )
                          ],
                        ),
                      );
                  });
            }else {
              return Center(child: Text("Loading..."));
            }
          },


        ):Center(child: Text("Check your network connection"),):Container(),
      )
    );
  }


}
