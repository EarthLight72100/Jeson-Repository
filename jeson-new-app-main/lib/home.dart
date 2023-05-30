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
import 'Instructor Screens/edit_screen.dart';

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
  // Map<dynamic, dynamic> courses = {};
  List<DataSnapshot> courses = [];

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
            classes.clear();
            // print(items);
            // print(items.runtimeType);
            for (final item in items) {
              // print(item.key);
              // print(item.value);
              DatabaseReference ref =
                  FirebaseDatabase.instance.ref(item.value.toString());
              DataSnapshot info = await ref.child("courses/${item.key}").get();
              if (info.value != null) {
                classes.add(info);
              } else {
                DatabaseReference ref = FirebaseDatabase.instance
                    .ref(AuthenticationHelper().user.uid);
                await ref.child("classes/${item.key}").remove();
              }
            }
          } else if (child.key == "courses") {
            var items = child.children;
            _singleton.courses.clear();
            for (final item in items) {
              _singleton.courses.add(item);
              // print(item);
              // print(item.runtimeType);
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

    // print(_singleton.courses);
    // print("CLASSES: $classes");

    _singleton.classCache = classes;
    _singleton.getEventsFromClasses();
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
                        Navigator.pushNamed(context, '/settings');
                        // AuthenticationHelper().signOut();
                        // Navigator.of(context)
                        //     .pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(51, 189, 189, 189)),
                      child: const Icon(Icons.settings, color: Colors.white)),
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
                      Navigator.pushNamed(context, '/settings');
                      // AuthenticationHelper().signOut();
                      // Navigator.of(context)
                      //     .pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(51, 189, 189, 189)),
                    child: const Icon(Icons.settings, color: Colors.white)),
              ),
              title: const Text("Courses"),
              actions: [
                IconButton(
                    onPressed: () {
                      _singleton.status = "creating";
                      _singleton.courseEvents?.clear();
                      Navigator.pushNamed(context, "/editScreen");
                    },
                    icon: const Icon(Icons.add, color: Colors.white))
              ],
            ),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                scrollDirection: Axis.vertical,
                children: _singleton.courses
                    .map((item) => CourseEntry(course: item))
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
  ClassEntry({super.key, required this.course});

  final _singleton = Singleton();

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
        date =
            "${date.substring(5, 7)}/${date.substring(8, 10)}/${date.substring(0, 4)} - ${date.substring(31, 33)}/${date.substring(34, 36)}/${date.substring(26, 30)}";
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
              onTap: () {
                _singleton.course = course;

                Navigator.pushNamed(context, '/viewCourseScreen');
              },
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
  CourseEntry({super.key, required this.course});

  final _singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    _singleton.courseName = null;
    _singleton.courseDescription = null;
    _singleton.courseStart = null;
    _singleton.courseEnd = null;
    if (_singleton.status != "editting") _singleton.courseEvents?.clear();

    String name = "";
    String courseCode = "";
    String date = "";
    String description = "";
    List<EventEntry> entryEvents = [];

    courseCode = course.key!;
    for (final child in course.children) {
      if (child.key == "name") {
        name = child.value as String;
      } else if (child.key == "date") {
        date = child.value as String;
      } else if (child.key == "description") {
        description = child.value as String;
      } else {
        // Map<String, dynamic> info = Map<String, dynamic>.from(child.value);
        String nameEvent = "";
        String descriptionEvent = "";
        String frequencyEvent = "";
        DateTime startDateEvent = DateTime.now();
        TimeOfDay startTimeEvent = TimeOfDay.now();
        DateTime endDateEvent = DateTime.now();
        TimeOfDay endTimeEvent = TimeOfDay.now();
        
        // TimeOfDay startTime = TimeOfDay(hour: info["startTime"].substring(11, 13), minute: info["startTime"].substring(14, 16));
        // TimeOfDay endTime = TimeOfDay(hour: info["endTime"].substring(11, 13), minute: info["endTime"].substring(14, 16));

        for (final element in child.children) {
          if (element.key == "name") {
            nameEvent = element.value as String;
          } else if (element.key == "frequency") {
            frequencyEvent = element.value as String;
          } else if (element.key == "description") {
            descriptionEvent = element.value as String;
          } else if (element.key == "startDate") {
            String item = element.value as String;
            startDateEvent = DateTime.parse(item);
          } else if (element.key == "startTime") {
            String item = element.value as String;
            // print(item.substring(10, 12));
            // print(item.substring(13, 15));
            startTimeEvent = TimeOfDay(
                hour: int.parse(item.substring(10, 12)),
                minute: int.parse(item.substring(13, 15)));
          } else if (element.key == "endDate") {
            String item = element.value as String;
            endDateEvent = DateTime.parse(item);
          } else if (element.key == "endTime") {
            String item = element.value as String;
            endTimeEvent = TimeOfDay(
                hour: int.parse(item.substring(10, 12)),
                minute: int.parse(item.substring(13, 15)));
          }
        }

        EventEntry entry = EventEntry(
          name: nameEvent,
          frequency: frequencyEvent,
          startDate: startDateEvent,
          startTime: startTimeEvent,
          endDate: endDateEvent,
          endTime: endTimeEvent,
          description: descriptionEvent,
        );

        if (nameEvent != "") {
          // _singleton.courseEvents ??= [];
          // _singleton.courseEvents?.add(entry);
          print("Adding $entry into entryEvents");
          entryEvents.add(entry);
        }
        
      }
    }

    final dateRange = date.split(' - ');
    // print(dateRange);

    return SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 75,
        height: SizeConfig.blockSizeVertical! * 10,
        child: InkWell(
          onTap: () {
            _singleton.course = course;
            Navigator.pushNamed(context, "/viewCourseScreen");
          },
          child: Card(
            elevation: 3.0,
            color: const Color.fromARGB(239, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal! * 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                            "${dateRange[0].substring(5, 7)}/${dateRange[0].substring(8, 10)}/${dateRange[0].substring(0, 4)} - ${dateRange[1].substring(5, 7)}/${dateRange[1].substring(8, 10)}/${dateRange[1].substring(0, 4)}",
                            style: TextStyle(fontSize: 16)),
                        Text(
                          courseCode,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  // SizedBox(width: SizeConfig.blockSizeHorizontal! * 10,),
                  ElevatedButton(
                    onPressed: () {
                      _singleton.courseName = name;
                      _singleton.courseDescription = description;
                      _singleton.courseStart = DateTime.parse(dateRange[0]);
                      _singleton.courseEnd = DateTime.parse(dateRange[1]);
                      _singleton.status = "editing";
                      _singleton.courseCode = courseCode;
                      _singleton.courseEvents = entryEvents;
                      print("Getting info for ${_singleton.courseName}, ${_singleton.courseEvents}");
                      Navigator.pushNamed(context, "/editScreen");
                    },
                    child: Icon(Icons.edit, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.blue, // <-- Button color
                      // foregroundColor: Colors.red, // <-- Splash color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Delete Course"),
                              content: Text(
                                  "Are you sure you want to delete this course?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      DatabaseReference mDatabase =
                                          FirebaseDatabase.instance.ref();
                                      mDatabase
                                          .child("courses/$courseCode")
                                          .remove()
                                          .then((value) => mDatabase
                                              .child(
                                                  "${AuthenticationHelper().user.uid}/courses/$courseCode")
                                              .remove());

                                      _singleton.courses.remove(course);
                                      Navigator.pop(context);
                                    },
                                    child: Text("Delete"))
                              ],
                            );
                          });
                    },
                    child: Icon(FontAwesomeIcons.trash, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor:
                          Color.fromARGB(255, 235, 81, 79), // <-- Button color
                      // foregroundColor: Colors.blue, // <-- Splash color
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
