import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  int counter = 1;
  final styletoText = TextStyle(fontFamily: "Poppins", fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text('hey AppBar'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('NUmber of touch', style: styletoText),
            Text(
              "10",
              style: styletoText,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Hola mundo");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
