import 'package:flutter/material.dart';
// import 'authentication.dart';
// import 'database.dart';
import 'package:jeson_flutter_app/database.dart';
// import 'main.dart';
// import 'classes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jeson_flutter_app/authentication.dart';
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
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Enter Course Code"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 30,
              child: const Card(
                color: Color(0xFFAB63E7),
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Please enter the course code and press the button to confirm your action.",
                        maxLines: 10,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),

            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // course code
                  SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 90,
                      height: 75,
                      child: TextFormField(
                        // initialValue: 'Input text',
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.class_),
                          labelText: 'Enter course code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100.0),
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
                    height: SizeConfig.blockSizeVertical,
                  ),

                  (_singleton.status == "subscribing")
                      ? SizedBox(
                          height: 54,
                          width: 184,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Respond to button press
                              _singleton.status = "viewing";
                              // print("Subscribing to class $courseCode");
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                DatabaseReference ref = FirebaseDatabase
                                    .instance
                                    .ref("courses/$courseCode");
                                DataSnapshot info = await ref.get();
                                // print("Here are the contents: ");
                                // print(info.key);
                                // print(info.value);
                                print(
                                    "Subscribing to class $courseCode: ${info.key!} ${info.value!}");
                                if (info.value != null) {
                                  DatabaseReference mDatabase =
                                      FirebaseDatabase.instance.ref();
                                  mDatabase
                                      .child("users")
                                      .child(AuthenticationHelper().user.uid)
                                      .child("classes")
                                      .update({info.key!: info.value}).then(
                                          (value) => Navigator.pop(context));
                                } else {
                                  print("Course does not exist");
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFAB63E7),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(24.0)))),
                            child: const Text(
                              'Subscribe',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 54,
                          width: 184,
                          child: ElevatedButton(
                            onPressed: () async {
                              print("Deleting class $courseCode");
                              // Respond to button press
                              _singleton.status = "viewing";
                              // print("Unsubscribing from class $courseCode");
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                DatabaseReference ref =
                                    FirebaseDatabase.instance.ref(
                                        "users/${AuthenticationHelper().user.uid}/classes/$courseCode");
                                DataSnapshot info = await ref.get();

                                if (info.value != null) {
                                  DatabaseReference mDatabase =
                                      FirebaseDatabase.instance.ref();
                                  mDatabase
                                      .child("users")
                                      .child(AuthenticationHelper().user.uid)
                                      .child("classes")
                                      .update({info.key!: null}).then(
                                          (value) => Navigator.pop(context));
                                } else {}
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFAB63E7),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(24.0)))),
                            child: const Text(
                              'Unsubscribe',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                  SizedBox(height: SizeConfig.blockSizeVertical! * 5)
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
