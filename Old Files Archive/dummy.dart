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
  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fireApp = Firebase.initializeApp();
  final Future<dynamic> _fireAuth = FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  late DatabaseReference test;

  void setup() async{
    FirebaseDatabase database = FirebaseDatabase.instance;
    test = database.ref();
    final snapshot = await test.child('$test').get();

    print(snapshot.value);

    // try {
    //   final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: "john@real.com",
    //       password: "cheese"
    //   );
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     print('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   print(e);
    // }
    //
    // try {
    //   final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: "john@real.com",
    //       password: "cheese"
    //   );
    //   print("Logged in!");
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     print('Wrong password provided for that user.');
    //   }
    // }
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
            return LoginPage(title: '98765');
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

  Future<dynamic> GetCredentials(emailAddress, password) async{
    try {
      final credential = FirebaseAuth.instance.signInAnonymously();
      // final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      //     email: "john@real.com",
      //     password: "cheese"
      // );
      print("Logged in!");

      return credential;
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
          final credentials = GetCredentials("john@real.com","cheese");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RandomWords(credential: credentials)),
          );
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
