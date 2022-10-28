import 'package:flutter/material.dart';
import 'main.dart';
import 'pagethree.dart';

class PageTwoState extends State<PageTwo> {
  final _biggerFont = const TextStyle(fontSize: 18);
  String _value = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: "Classes",
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
            if(_value == "Home"){
              //TODO - jump to class page; fix the next few lines
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomWords(title: "Home")),
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_sharp),
            onPressed: (){},
          )
          ]

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 240,
              width: 240,
              color: Colors.pink,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Class 1'),
                  const Text("Date"),
                  const Text("Informattion:"),
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  State<PageTwo> createState() => PageTwoState();
}