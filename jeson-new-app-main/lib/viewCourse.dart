import 'package:flutter/material.dart';
import 'size_config.dart';
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
            title: Text("$name ($courseCode)"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Color.fromARGB(255, 204, 204, 204),
              width: SizeConfig.blockSizeHorizontal! * 100,
              height: SizeConfig.blockSizeVertical! * 15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(description, maxLines: 7, style: TextStyle(fontSize: 18),),
              ),
            ),
            ListView(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                scrollDirection: Axis.vertical,
                children: [],
                shrinkWrap: true,
            ),
          ],
        ),
    );
  }
}