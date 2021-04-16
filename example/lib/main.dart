import 'package:flutter/material.dart';
import 'package:number_slide_animation/number_slide_animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Example(),
    );
  }
}

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  var number = 0.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Example"),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              number.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 60.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: NumberSlideAnimation(
              colorCurve: Curves.easeIn,
              colorDuration: Duration(milliseconds: 200),
              parseNumber: (val) => double.parse(val),
              number: number.toStringAsFixed(2),
              numberDuration: const Duration(milliseconds: 400),
              numberCurve: Curves.easeOutCubic,
              textStyle: TextStyle(
                fontSize: 60.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              increaseColor: Color(0xFF28AFB0),
              decreaseColor: Color(0xFFDF9097),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                number = number + 0.19;
              });
            },
            child: Text('up'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                number = number - 0.24;
              });
            },
            child: Text('down'),
          ),
        ],
      ),
    );
  }
}
