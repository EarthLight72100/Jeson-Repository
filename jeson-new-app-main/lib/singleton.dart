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

      for (final child in item.children) {
        if (child.key != "date" &&
            child.key != "description" &&
            child.key != "name") {
          print(child.key);
          EventMeta entry = EventMeta(child.key);
          for (final eventDetail in child.children) {
            if (eventDetail.key == "startDate") {
              entry.startDate = DateTime.parse(eventDetail.value.toString());
            } else if (eventDetail.key == "startTime") {
              entry.startTime = TimeOfDay(
                  hour:
                      int.parse(eventDetail.value.toString().substring(10, 12)),
                  minute: int.parse(
                      eventDetail.value.toString().substring(13, 15)));
            } else if (eventDetail.key == "endDate") {
              entry.endDate = DateTime.parse(eventDetail.value.toString());
            } else if (eventDetail.key == "endTime") {
              entry.endTime = TimeOfDay(
                  hour:
                      int.parse(eventDetail.value.toString().substring(10, 12)),
                  minute: int.parse(
                      eventDetail.value.toString().substring(13, 15)));
            }
          }
          result.add(entry);
        }
      }
    }
    return result;
  }
}

class EventMeta {
  final String? name;
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;

  EventMeta(this.name,
      {this.startDate, this.startTime, this.endDate, this.endTime});

  @override
  String toString() => (name != null) ? name! : "";
}
