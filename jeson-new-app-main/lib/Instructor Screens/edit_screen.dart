import 'package:flutter/material.dart';
import 'package:jeson_flutter_app/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class EditScreen extends StatefulWidget {
  EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // DateTime selectedDate = DateTime.now();
  DateTime startDate = DateTime.now();
  bool startDirty = false;
  DateTime endDate = DateTime.now();
  bool endDirty = false;

  Future<void> _selectDate(BuildContext context, bool pickStart) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (pickStart) ? startDate : endDate,
        firstDate: DateTime(2022, 8),
        lastDate: DateTime(2101));
    if (pickStart && picked != null && picked != startDate) {
      setState(() {
        startDirty = true;
        startDate = picked;
      });
    } else if (!pickStart && picked != null && picked != endDate) {
      setState(() {
        endDirty = true;
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Edit Screen")
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                          minLines: 5,
                          maxLines: 5,
                          decoration: InputDecoration(
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
                        children: [],
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
                                    onPressed: () {},
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
                                    onPressed: () {},
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
  // final DataSnapshot course;
  const EventEntry({super.key, required this.name, required this.frequency, required this.startDate, required this.startTime, required this.endDate, required this.endTime});
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name, style: TextStyle(fontSize: 18),),
                          Text(frequency, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(startTime.toString(), style: TextStyle(fontSize: 16),),
                          Text(" - ", style: TextStyle(fontSize: 16),),
                          Text(endTime.toString(), style: TextStyle(fontSize: 16),),
                        ],
                      )
                      
                    ],
                  ),
                ),
                // SizedBox(width: SizeConfig.blockSizeHorizontal! * 10,),
                ElevatedButton(
                  onPressed: () {},
                  child: Icon(Icons.edit, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.blue, // <-- Button color
                    // foregroundColor: Colors.red, // <-- Splash color
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
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