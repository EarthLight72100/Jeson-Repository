import 'package:firebase_database/firebase_database.dart';

import 'authentication.dart';

class Database {
  AuthenticationHelper auth = AuthenticationHelper();

  Future<void> addCourse(String courseCode, String date, String info) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("${auth.uid}/courses/$courseCode");

    ref.set({"name": courseCode, "date": date, "info": info});
  }

  Future<void> removeCourse(courseCode) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("${auth.uid}/courses/$courseCode");
    ref.remove();
  }

  Future<List<Map>?> getCourses() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("${auth.uid}/courses");
    DataSnapshot snapshot = await ref.get();
    List<Map> data = [];
    if (snapshot.exists) {
      if (snapshot.value != null) {
        for (var values in snapshot.children) {
          data.add(values.value as Map);
        }
      }
      print(data);
      return data;
    } else {
      print('No data available.');
      return null;
    }
  }
}
