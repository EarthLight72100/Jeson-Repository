import 'package:flutter/material.dart';
import 'size_config.dart';
import 'singleton.dart';
import 'Instructor Screens/edit_screen.dart';

class ViewCoursePage extends StatelessWidget {
  ViewCoursePage({super.key});

  final _singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    String name = "";
    String courseCode = "";
    String date = "";
    String description = "";
    _singleton.courseEvents!.clear();

    courseCode = _singleton.course!.key!;
    for (final child in _singleton.course!.children) {
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
          edittable: false,
        );

        print("DEBUG: ${_singleton.courseEvents}");
        _singleton.courseEvents!.add(entry);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        _singleton.courseEvents!.clear();
        return true;
      },
      child: Scaffold(
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
                child: Text(
                  description,
                  maxLines: 7,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            ListView(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: _singleton.courseEvents!.toList(),
            ),
          ],
        ),
      ),
    );
  }
}
