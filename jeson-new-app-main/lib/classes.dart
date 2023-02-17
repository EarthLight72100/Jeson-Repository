import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jeson_flutter_app/database.dart';
import 'home.dart';
import 'calendar.dart';
import 'course.dart';

class ClassesState extends State<PageTwo> {
  final _biggerFont = const TextStyle(fontSize: 18);
  String _value = " ";
  Database db = Database();

  // List<Map>? classes = [
  //   {'date': '1/1/2024', 'info': 'some information', 'name': 'class 1'}
  // ];
  List<Map>? classes;

  @override
  void initState() {
    super.initState();

    getCourses();
  }

  void getCourses() async {
    db.getCourses().then((data) {
      if (data != null) {
        setState(() {
          classes = data!;
        });
        print(classes);
      }
    });
  }

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
              items: const <DropdownMenuItem<String>>[
                DropdownMenuItem(
                  child: Text('Home'),
                  value: 'Home',
                ),
                DropdownMenuItem(child: Text('Classes'), value: 'Classes'),
                DropdownMenuItem(child: Text('Calendar'), value: 'Calendar'),
              ],
              onChanged: (String? value) {
                setState(() => _value = value!);
                if (_value == "Home") {
                  //TODO - jump to class page; fix the next few lines
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RandomWords(credential: "98765")),
                  );
                }
                if (_value == "Calendar") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CalendarPage(credential: "98765")),
                  );
                }
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_sharp),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CoursePage(credential: "My Calendar")),
                  ).then((value) {
                    getCourses();
                  });
                },
              )
            ]),
        body: classes != null
            ? ListView.builder(
                itemCount: classes!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: deviceHeight * 0.25,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    width: deviceWidth,
                    color: Colors.pink,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(classes![index]['name']!),
                          Text(classes![index]['date']!),
                          Text("Information: ${classes![index]['info']!}",
                              maxLines: 5),
                        ],
                      ),
                    ),
                  );
                },

              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No classes',
                      style: TextStyle(fontSize: 25),
                    )
                  ],
                ),
              ));
  }
}

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key, required this.credential}) : super(key: key);
  final credential;

  @override
  State<PageTwo> createState() => ClassesState();
}
