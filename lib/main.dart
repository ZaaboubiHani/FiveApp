import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Color Picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, Color> colors = {
    'purple': Colors.purple,
    'blue': Colors.blue,
    'yellow': Colors.yellow,
    'pink': Colors.pink,
    'teal': Colors.teal,
    'orange': Colors.orange
  };

  Color? selectedColor;

  @override
  void initState() {
    _getStoredColor();
    super.initState();
  }

  void _getStoredColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? colorname = prefs.getString('color');
    setState(() {
      selectedColor = colors[colorname];
    });
  }

  void _resetColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      selectedColor = null;
    });
  }

  void _setColor(String colorname, Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('color', colorname);

    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: selectedColor ?? Colors.black,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              heightFactor: 1.9,
              child: Text(
                'you are operating on ${Platform.operatingSystem}',
                style: const TextStyle(
                  fontSize: 22.0
                ),
              ),
            ),
            for (var entry in colors.entries)
              Container(
                margin: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: entry.value,
                    minimumSize: const Size(300, 60),
                  ),
                  child: Text(entry.key),
                  onPressed: () => _setColor(entry.key, entry.value),
                ),
              ),
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  
                  fixedSize: const Size(60, 60),
                ),
                
                child: const Text('Reset'),
                onPressed: () => _resetColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
