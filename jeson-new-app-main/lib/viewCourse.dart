import 'package:flutter/material.dart';
import 'singleton.dart';

class ViewCoursePage extends StatelessWidget {
  ViewCoursePage({super.key});

  final _singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    String name = "";
    String courseCode = "";
    String date = "";
    String description = "";

    courseCode = _singleton.course!.key!;
    for (final child in _singleton.course!.children) {
      if (child.key == "name") {
        name = child.value as String;
      } else if (child.key == "date") {
        date = child.value as String;
      } else if (child.key == "description") {
        description = child.value as String;
      }
    }

    return Scaffold(
        appBar: AppBar(
            title: Text("COURSE NAME HERE"),
        ),
    );
  }
}