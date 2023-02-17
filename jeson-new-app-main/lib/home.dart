import 'package:flutter/material.dart';
import 'classes.dart';
import 'calendar.dart';
import 'database.dart';

class _RandomWordsState extends State<RandomWords> {
  final _biggerFont = const TextStyle(fontSize: 18);
  String _value = " ";

  Database db = Database();
  List<Map>? classes;
  final ScrollController _scrollbarControllerClasses = ScrollController();

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

    double containerHeightRatio = 0.23;

    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          value: "Home",
          items: <DropdownMenuItem<String>>[
            DropdownMenuItem(
              child: const Text('Home'),
              value: 'Home',
            ),
            DropdownMenuItem(child: const Text('Classes'), value: 'Classes'),
            DropdownMenuItem(child: const Text('Calendar'), value: 'Calendar'),
          ],
          onChanged: (String? value) {
            setState(() => _value = value!);
            if (_value == "Classes") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageTwo(credential: "98765")),
              ).then((value) => getCourses());
            }
            if (_value == "Calendar") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CalendarPage(credential: "98765")),
              );
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.black12,
              height: deviceHeight - 80,
              width: deviceWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Announcements",
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                      color: Colors.white,
                      height: deviceHeight * containerHeightRatio,
                      width: deviceWidth * 0.9,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            //Feel free to customize the look of the font in any way you want
                            Text("-Announce 1"),
                            Text("-Announce 2"),
                          ])),
                  Text(
                    "Classes",
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                      color: Color(0xffa80e0e),
                      height: deviceHeight * containerHeightRatio,
                      width: deviceWidth * 0.9,
                      child: classes != null
                          ? Scrollbar(
                              controller: _scrollbarControllerClasses,
                              thumbVisibility: false,
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: classes!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(classes![index]['name']!),
                                        Text(classes![index]['date']!),
                                        Text(
                                            "Information: ${classes![index]['info']!}",
                                            maxLines: 5),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              ),
                            )
                          : Center(
                              child: Text(
                                'No classes',
                                style: TextStyle(fontSize: 25),
                              ),
                            )),
                  Text(
                    "Calendar",
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                      color: Colors.white,
                      height: deviceHeight * containerHeightRatio,
                      width: deviceWidth * 0.9,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            //Feel free to customize the look of the font in any way you want
                            Text("-Event 1: Date"),
                            Text("-Event 2: Date"),
                            Text("-Event 3: Date"),
                          ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key, required this.credential}) : super(key: key);
  final credential;

  @override
  State<RandomWords> createState() => _RandomWordsState();
}
