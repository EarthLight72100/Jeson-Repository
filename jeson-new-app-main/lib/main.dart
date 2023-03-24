import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'loading.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _fpApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fpApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: "Jeson App",
            routes: routeHolder,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // Add the 5 lines from here...
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFAB63E7),
                foregroundColor: Color(0xFFFFFFFF),
              ),
              primaryColor: Color(0xFFAB63E7),
            ),
          );
        }
        return Container();
      },
    );

    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     // Add the 5 lines from here...
    //     appBarTheme: const AppBarTheme(
    //       backgroundColor: Color(0xFFAB63E7),
    //       foregroundColor: Color(0xFFFFFFFF),
    //     ),
    //     primaryColor: Color(0xFFAB63E7),
    //   ),
    //   home: FutureBuilder(
    //       future: _fpApp,
    //       builder: (context, snapshot) {
    //         if (snapshot.hasError) {
    //           print("Error");
    //           return Text("Something went wrong.");
    //         } else if (snapshot.hasData) {
    //           print("snapshot has data");
    //           return Login();
    //         } else {
    //           return Center(child: CircularProgressIndicator());
    //         }
    //       }),
    // );
  }
}
