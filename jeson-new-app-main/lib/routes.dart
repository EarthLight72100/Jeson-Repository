import 'login.dart';
import 'signup.dart';
import 'checker.dart';
import 'package:jeson_flutter_app/Student Screens/add_course.dart';
import 'home.dart';

var routeHolder = {
  '/': (context) => const Checker(),
  '/login': (context) => Login(),
  '/signup': (context) => Signup(),
  '/addcourse': (context) => const AddCoursePage()
};
