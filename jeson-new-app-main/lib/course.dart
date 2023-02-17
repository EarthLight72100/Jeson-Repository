//TODO - Populate all information needed to make this page work
//TODO - This page is going to be the course registration page, so it needs TextField for input
//TODO - Can also use TextFormField if that's more up your alley
//TODO - Use this link: https://docs.flutter.dev/cookbook/forms/text-input

import 'package:flutter/material.dart';
import 'authentication.dart';
import 'database.dart';
import 'main.dart';
import 'classes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class CourseState extends State<CoursePage> {
  final _biggerFont = const TextStyle(fontSize: 18);

  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? courseCode;
  String? date;
  String? info;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Course Code"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     controller: myController,
            //     decoration: InputDecoration(
            //       hintText: "Enter course code",
            //     ),
            //   ),
            // ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // course code
                  TextFormField(
                    // initialValue: 'Input text',
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.class_),
                      labelText: 'Enter course code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          const Radius.circular(100.0),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      courseCode = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // password
                  TextFormField(
                    // initialValue: 'Input text',
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          const Radius.circular(100.0),
                        ),
                      ),
                    ),

                    onSaved: (val) {
                      date = val;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),
                  // Information
                  TextFormField(
                    // initialValue: 'Input text',
                    decoration: InputDecoration(
                      labelText: 'Information',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          const Radius.circular(100.0),
                        ),
                      ),
                    ),

                    onSaved: (val) {
                      info = val;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 54,
                    width: 184,
                    child: ElevatedButton(
                      onPressed: () {
                        // Respond to button press

                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          Database db = Database();

                          db.addCourse(courseCode!, date!, info!).then((value) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                'Class added',
                                style: TextStyle(fontSize: 16),
                              ),
                            ));
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFAB63E7),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)))),
                      child: Text(
                        'Add course',
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
      // floatingActionButton: FloatingActionButton(
      //   // When the user presses the button, show an alert dialog containing
      //   // the text that the user has entered into the text field.
      //   onPressed: () {
      //     showDialog(
      //       context: context,
      //       builder: (context) {
      //         return AlertDialog(
      //           // Retrieve the text the that user has entered by using the
      //           // TextEditingController.
      //           content: Text(myController.text),
      //         );
      //       },
      //     );
      //   },
      //   tooltip: 'Show me the value!',
      //   child: const Icon(Icons.text_fields),
      // ),
    );
  }
}

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key, required this.credential}) : super(key: key);
  final credential;

  @override
  State<CoursePage> createState() => CourseState();
}
