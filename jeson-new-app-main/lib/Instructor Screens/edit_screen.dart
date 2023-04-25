import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jeson_flutter_app/size_config.dart';
import 'package:jeson_flutter_app/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jeson_flutter_app/singleton.dart';
import 'dart:async';

class EditScreen extends StatefulWidget {
  EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  final _singleton = Singleton();

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  // DateTime selectedDate = DateTime.now();
  DateTime startDate = DateTime.now();
  bool startDirty = false;
  DateTime endDate = DateTime.now();
  bool endDirty = false;

  @override
  void initState() {
    super.initState();
    Singleton().addListener(() {
      if (mounted) setState(() {});
    });
  }

  Future<void> _selectDate(BuildContext context, bool pickStart) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (pickStart) ? startDate : endDate,
        firstDate: DateTime(2022, 8),
        lastDate: DateTime(2101));
    if (pickStart && picked != null && picked != startDate) {
      if (mounted) setState(() {
        startDirty = true;
        startDate = picked;
      });
    } else if (!pickStart && picked != null && picked != endDate) {
      if (mounted) setState(() {
        endDirty = true;
        endDate = picked;
      });
    }
  }

  String generateCourseCode() {
    String code = "";
    for (int i = 0; i < 6; i++) {
      code += String.fromCharCode(65 + (Random().nextInt(26)));
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    if (_singleton.courseName != null) {
      nameController.text = _singleton.courseName as String;
      descController.text = _singleton.courseDescription as String;
      startDate = _singleton.courseStart as DateTime;
      startDirty = true;
      endDate = _singleton.courseEnd as DateTime;
      endDirty = true;
    }

    return Scaffold(
        appBar: AppBar(
            title: const Text("Edit Screen"),
            automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0))
                      ),
                      hintText: 'Course Name',
                    ),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: 54,
                          width: SizeConfig.blockSizeHorizontal! * 40,
                          child: ElevatedButton(
                              onPressed: () {
                                _selectDate(context, true);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB63E7),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                              child: Text(
                              (!startDirty) ? 'Start Date' : "${startDate.month}/${startDate.day}/${startDate.year}",
                              style: const TextStyle(fontSize: 24),
                              ),
                          ),
                      ),
        
                      SizedBox(
                          height: 54,
                          width: SizeConfig.blockSizeHorizontal! * 40,
                          child: ElevatedButton(
                              onPressed: () {
                                _selectDate(context, false);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB63E7),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                              child: Text(
                              (!endDirty) ? 'End Date': "${endDate.month}/${endDate.day}/${endDate.year}",
                              style: const TextStyle(fontSize: 24),
                              ),
                          ),
                      ),
        
                      // TextButton(onPressed: () {
                      //   _selectDate(context, true);
                      // }, child: Text("Start Date")),
                      // TextButton(onPressed: () {
                      //   _selectDate(context, false);
                      // }, child: Text("End Date"))
                    ],
                  ),
                  Container(
                      // color: Colors.red,
                      height: SizeConfig.blockSizeVertical! * 20,
                      width: SizeConfig.blockSizeHorizontal! * 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                          controller: descController,
                          minLines: 5,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24.0))
                            ),
                            hintText: 'Course Description',
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 54,
                        width: SizeConfig.blockSizeHorizontal! * 85,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/eventScreen');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFAB63E7),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                            child: const Text(
                            'Create Event',
                            style: TextStyle(fontSize: 24),
                            ),
                        ),
                    ),
                  ),
                  Container(
                      color: Colors.blue,
                      height: SizeConfig.blockSizeVertical! * 30,
                    child: ListView(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        scrollDirection: Axis.vertical,
                        children: _singleton.events,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            SizedBox(
                                height: 54,
                                width: SizeConfig.blockSizeHorizontal! * 40,
                                child: ElevatedButton(
                                    onPressed: () {
                                      _singleton.courseName = null;
                                      _singleton.courseDescription = null;
                                      _singleton.courseStart = null;
                                      _singleton.courseEnd = null;
                                      _singleton.events.clear();
                                      _singleton.status = "viewing";
                                      _singleton.courseCode = null;
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFAB63E7),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                                    child: const Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: 24),
                                    ),
                                ),
                            ),
                            SizedBox(
                                height: 54,
                                width: SizeConfig.blockSizeHorizontal! * 40,
                                child: ElevatedButton(
                                    onPressed: () {

                                      var data = {
                                        "name": nameController.text,
                                        "description": descController.text,
                                        "date": "$startDate - $endDate"
                                      };

                                      DatabaseReference mDatabase =
                                        FirebaseDatabase.instance.ref();
                                      String courseCode = (_singleton.courseCode != null) ? _singleton.courseCode as String : generateCourseCode();
                                      mDatabase.child("${AuthenticationHelper().user.uid}/courses/$courseCode").update(data).then((value) {
                                        mDatabase.child("courses/$courseCode").set(AuthenticationHelper().user.uid);
                                        _singleton.events.clear();
                                        Navigator.pop(context);
                                      });
                                      
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFAB63E7),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                                    child: const Text(
                                    'Save',
                                    style: TextStyle(fontSize: 24),
                                    ),
                                ),
                            ),
                        ],
                    ),
                  )
                  
        
              ],
          ),
        ),
    );
  }
}

class CourseForm extends StatefulWidget {
  const CourseForm({super.key});

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



class EventEntry extends StatelessWidget {

  final _singleton = Singleton();
  // final DataSnapshot course;
  EventEntry({super.key, required this.name, required this.frequency, required this.startDate, required this.startTime, required this.endDate, required this.endTime});
  final String name;
  final String frequency;
  final DateTime startDate;
  final TimeOfDay startTime;
  final DateTime endDate;
  final TimeOfDay endTime;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 75,
        height: SizeConfig.blockSizeVertical! * 10,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name, style: TextStyle(fontSize: 18),),
                          SizedBox(width: SizeConfig.blockSizeHorizontal! * 3,),
                          Text(frequency, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          Text("${startTime.hour}:${(startTime.minute < 10) ? 0 : ''}${startTime.minute}", style: TextStyle(fontSize: 16),),
                          Text(" - ", style: TextStyle(fontSize: 16),),
                          Text("${endTime.hour}:${(endTime.minute < 10) ? 0 : ''}${endTime.minute}", style: TextStyle(fontSize: 16),),
                        ],
                      )
                      
                    ],
                  ),
                ),
                // SizedBox(width: SizeConfig.blockSizeHorizontal! * 10,),
                ElevatedButton(
                  onPressed: () {

                    // name: nameController.text,
                    // frequency: frequency,
                    // startDate: startDate,
                    // startTime: startTime,
                    // endDate: endDate,
                    // endTime: endTime,
                    _singleton.status = "eventEdit";
                    _singleton.frequencyEvent = frequency;
                    _singleton.nameEvent = name;
                    _singleton.startDateEvent = startDate;
                    _singleton.startTimeEvent = startTime;
                    _singleton.endDateEvent = endDate;
                    _singleton.endTimeEvent = endTime;

                    Navigator.pushNamed(context, '/eventScreen');
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
                    _singleton.removeEvent(this);
                    
                    // for (int i = 0; i < _singleton.events.length; i++)
                    // {
                    //   if (_singleton.events[i] == this)
                    //   {
                    //     print("TESTING");
                    //   }
                    // }
                  },
                  child: Icon(FontAwesomeIcons.trash, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Color.fromARGB(255, 235, 81, 79), // <-- Button color
                    // foregroundColor: Colors.blue, // <-- Splash color
                  ),
                )
              ],
            ),
          ),
        ));
  }
}