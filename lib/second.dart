import 'package:flutter/material.dart';

class Second extends StatelessWidget {

  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(name,style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }

  Second(this.name);
}
