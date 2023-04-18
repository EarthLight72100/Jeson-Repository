import 'package:firebase_database/firebase_database.dart';
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
  String accountType = "";
  String status = "viewing";

  String? nameEvent;
  String? frequencyEvent;
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

  List<EventEntry> events = [];

  void addEvent(EventEntry event) {
    events.add(event);
    print("HELLO");
    // notifyListeners();
    print(events);
  }

  void removeEvent(EventEntry event) {
    events.remove(event);
    print("BYE");
    // notifyListeners();
    print(events);
  }
}