import 'login.dart';
import 'signup.dart';
import 'checker.dart';
import 'home.dart';

var routeHolder = {
  '/': (context) => const Checker(),
  '/login': (context) => Login(),
  '/signup': (context) => Signup(),
};
