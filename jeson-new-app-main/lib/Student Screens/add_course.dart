import 'package:flutter/material.dart';
// import 'authentication.dart';
// import 'database.dart';
import 'package:jeson_flutter_app/database.dart';
// import 'main.dart';
// import 'classes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jeson_flutter_app/size_config.dart';
import 'package:jeson_flutter_app/singleton.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({Key? key}) : super(key: key);

  @override
  State<AddCoursePage> createState() => AddCourseState();
}

class AddCourseState extends State<AddCoursePage> {
  Singleton _singleton = Singleton();

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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            Card(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    maxLines: 10,
                  )),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // course code
                  SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 80,
                      height: 75,
                      child: TextFormField(
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
                        onChanged: (val) {
                          courseCode = val;
                        },
                      )),
                  //   SizedBox(
                  //     height: 20,
                  //   ),
                  //   // password
                  //   TextFormField(
                  //     // initialValue: 'Input text',
                  //     decoration: InputDecoration(
                  //       labelText: 'Date',
                  //       prefixIcon: Icon(Icons.calendar_month),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(
                  //           const Radius.circular(100.0),
                  //         ),
                  //       ),
                  //     ),

                  //     onSaved: (val) {
                  //       date = val;
                  //     },
                  //     validator: (value) {
                  //       if (value!.isEmpty) {
                  //         return 'Please enter some text';
                  //       }
                  //       return null;
                  //     },
                  //   ),

                  //   SizedBox(height: 20),
                  //   // Information
                  //   TextFormField(
                  //     // initialValue: 'Input text',
                  //     decoration: InputDecoration(
                  //       labelText: 'Information',
                  //       prefixIcon: Icon(Icons.description),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(
                  //           const Radius.circular(100.0),
                  //         ),
                  //       ),
                  //     ),

                  //     onSaved: (val) {
                  //       info = val;
                  //     },
                  //     validator: (value) {
                  //       if (value!.isEmpty) {
                  //         return 'Please enter some text';
                  //       }
                  //       return null;
                  //     },
                  //   ),

                  SizedBox(
                    height: 100,
                  ),

                  (_singleton.status == "subscribing") ? SizedBox(
                    height: 54,
                    width: 184,
                    child: ElevatedButton(
                      onPressed: () {
                        // Respond to button press
                        _singleton.status = "viewing";
                        print("Subscribing to class $courseCode");
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          Database db = Database();

                          // db.addCourse(courseCode!, date!, info!).then((value) {
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(const SnackBar(
                          //     content: Text(
                          //       'Class added',
                          //       style: TextStyle(fontSize: 16),
                          //     ),
                          //   ));
                          // });

                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFAB63E7),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)))),
                      child: Text(
                        'Subscribe',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ) : SizedBox(
                    height: 54,
                    width: 184,
                    child: ElevatedButton(
                      onPressed: () {
                        // Respond to button press
                        _singleton.status = "viewing";
                        print("Unsubscribing from class $courseCode");
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          Database db = Database();

                          // db.addCourse(courseCode!, date!, info!).then((value) {
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(const SnackBar(
                          //     content: Text(
                          //       'Class added',
                          //       style: TextStyle(fontSize: 16),
                          //     ),
                          //   ));
                          // });

                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFAB63E7),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)))),
                      child: Text(
                        'Unsubscribe',
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
