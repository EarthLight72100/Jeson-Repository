import 'package:flutter/material.dart';
import 'pagetwo.dart';
import 'pagethree.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(          // Add the 5 lines from here...
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFAB63E7),
          foregroundColor: Color(0xFFFFFFFF),
        ),
      ),                         // ... to here.
      home: const RandomWords(title: 'Home'),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _biggerFont = const TextStyle(fontSize: 18);
  String _value = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: "Home",
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem(
              child: const Text('Home'),
              value: 'Home',
            ),
            DropdownMenuItem(
                child: const Text('Classes'),
                value: 'Classes'
            ),
            DropdownMenuItem(
                child: const Text('Calendar'),
                value: 'Calendar'
            ),
          ],

          onChanged: (String? value) {
            setState(() => _value = value!);
            if(_value == "Classes"){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageTwo(title: "My Classes")),
              );
            }
            if(_value == "Calendar"){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageThree(title: "My Calendar")),
              );
            }
          },
        ),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Announcements",
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "Classes",
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "Calendar",
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RandomWords> createState() => _RandomWordsState();
}