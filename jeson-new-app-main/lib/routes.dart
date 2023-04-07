import 'login.dart';
import 'signup.dart';
import 'checker.dart';
import 'package:jeson_flutter_app/Student Screens/add_course.dart';
import 'package:jeson_flutter_app/Instructor Screens/edit_screen.dart';
import 'home.dart';
import 'initialization.dart';
import 'settings.dart';

var routeHolder = {
  '/': (context) => const Checker(),
  '/login': (context) => Login(),
  '/signup': (context) => Signup(),
  '/addcourse': (context) => const AddCoursePage(),
  '/homescreen': (context) => const HomeScreen(credential: null),
  '/initScreen': (context) => InitializationScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/editScreen': (context) => const EditScreen(),
};
