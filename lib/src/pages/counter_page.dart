import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 1; // Definición de la variable _counter

  final TextStyle styletoText =
      TextStyle(fontSize: 24); // Definición del estilo del texto

  void _incrementCounter() {
    print("Increment pressed");
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    print("decrement pressed");
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      print("reset pressed");
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text('Ramdom text'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Number of touch', style: styletoText),
            Text(
              "$_counter",
              style: styletoText,
            ),
          ],
        ),
      ),
      floatingActionButton: _crearBtn(),
    );
  }

  Widget _crearBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 40),
        FloatingActionButton(
          child: Icon(Icons.remove),
          onPressed: _decrementCounter, // Asignar la función de disminuir
        ),
        SizedBox(width: 20),
        FloatingActionButton(
          child: Icon(Icons.exposure_zero),
          onPressed: _resetCounter, // Asignar la función de reiniciar
        ),
        SizedBox(width: 20),
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _incrementCounter, // Asignar la función de aumentar
        ),
      ],
    );
  }
}
