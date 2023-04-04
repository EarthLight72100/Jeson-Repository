import 'package:flutter/material.dart';
import 'package:jeson_flutter_app/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'size_config.dart';
import 'dart:async';
import 'classes.dart';
import 'calendar.dart';
import 'database.dart';
import 'singleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.credential}) : super(key: key);
  final credential;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final _biggerFont = const TextStyle(fontSize: 18);
  String _value = " ";

  final Singleton _singleton = Singleton();

  Database db = Database();
  // List<Map>? courses;
  // final ScrollController _scrollbarControllerClasses = ScrollController();

  @override
  void initState() {
    super.initState();

    // getCourses();
  }

  // void getCourses() async {
  //   db.getCourses().then((data) {
  //     if (data != null) {
  //       if (mounted) {
  //         setState(() {
  //           courses = data;
  //         });
  //       }
  //       // print(courses);
  //     }
  //   });
  // }

  StreamSubscription<DatabaseEvent>? announcementsListener;
  StreamSubscription<DatabaseEvent>? userDataListener;
  List<DataSnapshot> announcements = [];
  List<DataSnapshot> classes = [];
  Map<dynamic, dynamic> courses = {};

  @override
  Widget build(BuildContext context) {
    //the width will be a media query the asks the machine what the dimensions of the screen are, then we'll steal the width
    MediaQueryData data = MediaQuery.of(context);
    double deviceWidth = data.size.width;
    double deviceHeight = data.size.height;

    double containerHeightRatio = 0.23;

    // print("AAAAAA");
    // print(_singleton.userData?.child("accountType"));

    if (announcementsListener == null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("announcements");
      announcementsListener = ref.onValue.listen((event) async {
        announcements.clear();
        for (final child in event.snapshot.children) {
          // Handle the post.
          // print("TESTING");
          // print(child.key);
          announcements.add(child);
          if (mounted) setState(() {});
        }
      });
    }

    if (userDataListener == null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref(AuthenticationHelper().user.uid);
      userDataListener = ref.onValue.listen((event) async {
        classes.clear();
        for (final child in event.snapshot.children) {
          // Handle the post.
          // print("TESTING");
          // print(child.key);
          // classes.add(child);
          if (child.key == "classes") {
            var items = child.children;
            // print(items);
            // print(items.runtimeType);
            for (final item in items) {
              // print(item.key);
              // print(item.value);
              DatabaseReference ref =
                  FirebaseDatabase.instance.ref(item.value.toString());
              DataSnapshot info = await ref.child("courses/${item.key}").get();
              classes.add(info);
            }
          } else if (child.key == "courses") {
            var items = child.children;
            for (final item in items) {
              // courses?.add(item);
            }
          }
          if (mounted) setState(() {});
        }
      });
    }

    // print(courses);

    // if (_singleton.accountType == "Student") {
    //   print("Student");
    // } else {
    //   print("Instructor");
    // }

    return (_singleton.accountType == "Student")
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(children: [
                DropdownButton<String>(
                  dropdownColor: const Color(0xFFAB63E7),
                  value: "Home",
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: 'Home',
                      child: Text(
                        'Home',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // DropdownMenuItem(child: const Text('Classes'), value: 'Classes'),
                    DropdownMenuItem(
                        value: 'Calendar',
                        child: Text('Calendar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ],
                  onChanged: (String? value) {
                    if (mounted) setState(() => _value = value!);
                    // if (_value == "Classes") {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => PageTwo(credential: "98765")),
                    //   ).then((value) => getCourses());
                    // }
                    if (_value == "Calendar") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CalendarPage(credential: "98765")),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 45,
                  width: 45,
                  child: TextButton(
                      onPressed: () {
                        AuthenticationHelper().signOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(51, 189, 189, 189)),
                      child: const Icon(Icons.logout, color: Colors.white)),
                )
              ]),
              actions: [
                IconButton(
                    onPressed: () {
                      _singleton.status = "unsubscribing";
                      Navigator.pushNamed(context, '/addcourse');
                    },
                    icon: const Icon(Icons.remove, color: Colors.white)),
                IconButton(
                    onPressed: () {
                      _singleton.status = "subscribing";
                      Navigator.pushNamed(context, '/addcourse');
                    },
                    icon: const Icon(Icons.add, color: Colors.white))
              ],
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
                        SizedBox(height: SizeConfig.blockSizeVertical! * 3),
                        const Text(
                          "Announcements",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            width: SizeConfig.blockSizeHorizontal! * 93,
                            height: SizeConfig.blockSizeVertical! * 20,
                            child: Card(
                                color: Color.fromARGB(205, 255, 255, 255),
                                child: Container(
                                    // color: Colors.white,
                                    // height: deviceHeight * containerHeightRatio,
                                    // width: deviceWidth * 0.9,
                                    child: ListView(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  scrollDirection: Axis.vertical,
                                  children: announcements
                                      .map((item) =>
                                          AnnouncementEntry(announcement: item))
                                      .toList(),
                                )))),
                        SizedBox(height: SizeConfig.blockSizeVertical! * 3),
                        const Text(
                          "Classes",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            width: SizeConfig.blockSizeHorizontal! * 93,
                            height: SizeConfig.blockSizeVertical! * 50,
                            child: Card(
                                color: const Color.fromARGB(205, 255, 255, 255),
                                child: ListView(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  scrollDirection: Axis.vertical,
                                  children: classes
                                      .map((item) => ClassEntry(course: item))
                                      .toList(),
                                ))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: SizedBox(
                height: 45,
                width: 45,
                child: TextButton(
                    onPressed: () {
                      AuthenticationHelper().signOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(51, 189, 189, 189)),
                    child: const Icon(Icons.logout, color: Colors.white)),
              ),
              title: const Text("Courses"),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add, color: Colors.white))
              ],
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                scrollDirection: Axis.vertical,
                children: announcements
                    .map((item) => AnnouncementEntry(announcement: item))
                    .toList(),
              ),
            ),
          );
  }
}

class AnnouncementEntry extends StatelessWidget {
  final DataSnapshot announcement;
  const AnnouncementEntry({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    String title = "";
    String description = "";
    String date = "";
    for (final child in announcement.children) {
      if (child.key == "title") {
        title = child.value as String;
      } else if (child.key == "date") {
        date = child.value as String;
      } else if (child.key == "description") {
        description = child.value as String;
      }
    }
    return SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 75,
        height: SizeConfig.blockSizeVertical! * 12,
        child: Card(
          color: const Color.fromARGB(239, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$title, $date"),
                  Text(
                    description,
                    maxLines: 3,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class ClassEntry extends StatelessWidget {
  final DataSnapshot course;
  const ClassEntry({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    String name = "";
    String description = "";
    String date = "";
    for (final child in course.children) {
      if (child.key == "name") {
        name = child.value as String;
      } else if (child.key == "date") {
        date = child.value as String;
      } else if (child.key == "description") {
        description = child.value as String;
      }
    }
    return SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 75,
        height: SizeConfig.blockSizeVertical! * 12,
        child: Card(
          color: const Color.fromARGB(239, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$name, $date"),
                  Text(
                    description,
                    maxLines: 4,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

// Instructor Cards below
class CourseEntry extends StatelessWidget {
  final DataSnapshot course;
  const CourseEntry({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    String name = "";
    String courseCode = "";
    String date = "";

    courseCode = course.key!;
    for (final child in course.children) {
      if (child.key == "name") {
        name = child.value as String;
      } else if (child.key == "date") {
        date = child.value as String;
      }
    }

    return SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 75,
        height: SizeConfig.blockSizeVertical! * 12,
        child: Card(
          color: const Color.fromARGB(239, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$name, $date"),
                  Text(
                    courseCode,
                    maxLines: 4,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
