import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes.dart';
// import 'loading.dart';
// import 'login.dart';

/*
  AMDREO APP

  juhyung122000@gmail.com: send your icon to this address by end of 3/30

  TITLE: AMDREO APP

  Privacy Policy: https://doc-hosting.flycricket.io/amdreo-app-privacy-policy/efc5e30d-864d-431c-85d0-9ceddd927402/privacy

  Terms and Conditions: https://doc-hosting.flycricket.io/amdreo-app-terms-of-use/9f38feb1-b35e-400e-8a6e-a2f052c3f76b/terms 
 */

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
              primaryColor: const Color(0xFFAB63E7),
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
