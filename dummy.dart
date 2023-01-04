import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fireApp = Firebase.initializeApp();
  final Future<void> _fireAuth = FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  late DatabaseReference test;

  void setup() async{
    final database = FirebaseDatabase.instance;
    test = database.ref("test");

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "john@real.com",
          password: "cheese"
      );
      print("Logged in!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

    //listen to user auth changes
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    //listen to token changes
    FirebaseAuth.instance
        .idTokenChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    //listen to user changes
    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    setup();
    return MaterialApp(
      title: 'App Name',
      theme: ThemeData(          // Add the 5 lines from here...
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFAB63E7),
          foregroundColor: Color(0xFFFFFFFF),
        ),
      ),                         // ... to here.
      home: FutureBuilder(
        future: _fireApp,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            print("Error: Something happened while initializing Firebase.");
            return Text("Something went wrong");
          } else if (snapshot.hasData){
            return LoginPage(credential: '98765');
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class LoginPageState extends State<LoginPage> {
  final _biggerFont = const TextStyle(fontSize: 18);
  String _value = " ";

  void GetCredentials(emailAddress, password) async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password
      );
      print("Logged in!");
      } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //the width will be a media query the asks the machine what the dimensions of the screen are, then we'll steal the width
    MediaQueryData data = MediaQuery.of(context);
    double deviceWidth = data.size.width;
    double deviceHeight = data.size.height;

    double containerHeightRatio = 0.23;

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello!"),
      ),
      body: FloatingActionButton(
        onPressed:(){
          GetCredentials("john@real.com","cheese");
        }
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => LoginPageState();
}
