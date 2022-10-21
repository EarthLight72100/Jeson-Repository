import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'pagetwo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
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
          ],

          onChanged: (String? value) {
            setState(() => _value = value!);
            if(_value == "Classes"){
              //TODO - jump to class page; fix the next few lines
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageTwo(title: "My Classes")),
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

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
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