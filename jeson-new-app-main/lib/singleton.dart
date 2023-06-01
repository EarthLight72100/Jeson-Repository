import 'package:firebase_database/firebase_database.dart';
import 'package:jeson_flutter_app/utils.dart';
import 'Instructor Screens/edit_screen.dart';
import 'package:flutter/material.dart';

class Singleton extends ChangeNotifier {
  static final Singleton _instance = Singleton._internal();

  // passes the instantiation to the _instance object
  factory Singleton() => _instance;

  // initialize our variables
  Singleton._internal() {
    // _userData = null;
  }

  DataSnapshot? userData;
  String accountType = "Student";
  String status = "viewing";

  List<DataSnapshot> classes = [];
  List<DataSnapshot>? classCache;
  List<DataSnapshot> courses = [];

  String? nameEvent;
  String? frequencyEvent;
  String? descriptionEvent;
  DateTime? startDateEvent;
  TimeOfDay? startTimeEvent;
  DateTime? endDateEvent;
  TimeOfDay? endTimeEvent;

  // name: nameController.text,
  // frequency: frequency,
  // startDate: startDate,
  // startTime: startTime,
  // endDate: endDate,
  // endTime: endTime,

  // List<EventEntry> events = [];

  void addEvent(EventEntry event) {
    courseEvents?.add(event);
    print("Adding: $event to $courseEvents");
    notifyListeners();
    print(courseEvents);
  }

  void removeEvent(EventEntry event) {
    courseEvents?.remove(event);
    // print("BYE");
    notifyListeners();
    // print(events);
  }

  // CREATE COURSE FIELDS
  DateTime? newCourseStart;
  DateTime? newCourseEnd;

  // EDIT COURSE FIELDS
  String? courseCode;
  String? courseName;
  DateTime? courseStart;
  DateTime? courseEnd;
  String? courseDescription;
  List<EventEntry>? courseEvents;
  EventEntry? selectedEvent;

  // VIEW COURSE FIELDS
  DataSnapshot? course;

  List<EventMeta> getEventsFromClasses() {
    final singleton = Singleton();
    List<EventMeta> result = [];
    for (int i = 0; i < singleton.classCache!.length; i++) {
      // print("AAAAAAA");
      DataSnapshot item = singleton.classCache![i];
      String courseName = "";
      String courseDate = "";
      List<EventMeta> temp = [];

      for (final child in item.children) {
        if (child.key != "date" &&
            child.key != "description" &&
            child.key != "name") {
          print(child.key);
          // int isMultiDay = 0;
          bool isWeekly = false;
          bool isMonthly = false;

          DateTime start = DateTime.now();
          DateTime end = DateTime.now();

          EventMeta entry = EventMeta(child.key);
          for (final eventDetail in child.children) {
            if (eventDetail.key == "startDate") {
              entry.startDate = DateTime.parse(eventDetail.value.toString());
              start = DateTime.parse(eventDetail.value.toString());
            } else if (eventDetail.key == "startTime") {
              entry.startTime = TimeOfDay(
                  hour:
                      int.parse(eventDetail.value.toString().substring(10, 12)),
                  minute: int.parse(
                      eventDetail.value.toString().substring(13, 15)));
            } else if (eventDetail.key == "endDate") {
              entry.endDate = DateTime.parse(eventDetail.value.toString());
              end = DateTime.parse(eventDetail.value.toString());
            } else if (eventDetail.key == "endTime") {
              entry.endTime = TimeOfDay(
                  hour:
                      int.parse(eventDetail.value.toString().substring(10, 12)),
                  minute: int.parse(
                      eventDetail.value.toString().substring(13, 15)));
            } else if (eventDetail.key == "frequency") {
              entry.frequency = eventDetail.value.toString();
              if (eventDetail.value == "Weekly") {
                isWeekly = true;
              } else if (eventDetail.value == "Monthly") {
                isMonthly = true;
              }
            }
            
          }
          temp.add(entry);

          // This is where we handle multi-day
          if (start.isBefore(end)) {
            while (start.isBefore(end)) {
              start = start.add(const Duration(days: 1));
              EventMeta additionalEntry = entry.copyWith(startDate: start);
              temp.add(additionalEntry);
            }
          }
        } else if (child.key == "date") {
          courseDate = child.value.toString();
        } else if (child.key == "name") {
          courseName = child.value.toString();
        }
      }

      // Add course metadata to each event here
      for (EventMeta event in temp) {
        event.courseDate = courseDate;
        event.courseName = courseName;
        
        result.add(event);
      }


    }
    return result;
  }
}

class EventMeta {
  final String? name;
  String? frequency;
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;

  // course metadata
  String? courseName;
  String? courseDate;

  EventMeta(this.name,
      {this.frequency, this.startDate, this.startTime, this.endDate, this.endTime, this.courseName, this.courseDate});

  EventMeta copyWith({
    String? name,
    String? frequency,
    DateTime? startDate,
    TimeOfDay? startTime,
    DateTime? endDate,
    TimeOfDay? endTime,
    String? courseName,
    String? courseDate
  }) {
    return EventMeta(
      name ?? this.name,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      endDate: endDate ?? this.endDate,
      endTime: endTime ?? this.endTime,
      courseName: courseName ?? this.courseName,
      courseDate: courseDate ?? this.courseDate,
    );
  }

  @override
  String toString() => (name != null) ? name! : "";
}
