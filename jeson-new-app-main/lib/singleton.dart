import 'package:firebase_database/firebase_database.dart';

class Singleton {
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
}