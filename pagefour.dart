//TODO - Populate all information needed to make this page work
//TODO - This page is going to be the course registration page, so it needs TextField for input
//TODO - Can also use TextFormField if that's more up your alley
//TODO - Use this link: https://docs.flutter.dev/cookbook/forms/text-input

import 'package:flutter/material.dart';
import 'main.dart';
import 'pagetwo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


class PageFourState extends State<PageFour>{
  final _biggerFont = const TextStyle(fontSize: 18);
  String _value = " ";
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
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
            TextField(
              controller: myController,
              decoration: InputDecoration(
                hintText: "Enter course code",
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}

class PageFour extends StatefulWidget {
  const PageFour({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  State<PageFour> createState() => PageFourState();
}
