import 'package:flutter/material.dart';
import 'main.dart';
import 'pagethree.dart';
import 'pagefour.dart';

class PageTwoState extends State<PageTwo> {
  final _biggerFont = const TextStyle(fontSize: 18);
  String _value = " ";

  @override
  Widget build(BuildContext context) {
    //the width will be a media query the asks the machine what the dimensions of the screen are, then we'll steal the width
    MediaQueryData data = MediaQuery.of(context);
    double deviceWidth = data.size.width;
    double deviceHeight = data.size.height;

    const Key centerKey = ValueKey<String>('bottom-sliver-list');
    final double split = 25;

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
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageFour(title: "My Calendar")),
              );
            },
          )
          ]

      ),
      body: SingleChildScrollView(
          child: Column(
            children :<Widget>[
              Container(
                height: deviceHeight * 0.25,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: deviceWidth,
                color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Class 1'),
                    const Text("Date"),
                    const Text("Information:"),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key, required this.credential}) : super(key: key);
  final credential;


  @override
  State<PageTwo> createState() => PageTwoState();
}
