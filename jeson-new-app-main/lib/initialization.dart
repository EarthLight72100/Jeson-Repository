import 'package:flutter/material.dart';
import 'singleton.dart';
import 'authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';
import 'loading.dart';

class InitializationScreen extends StatelessWidget {
  InitializationScreen({super.key});

  final Singleton _singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseDatabase.instance.ref(AuthenticationHelper().user.uid).get(),
        builder: ((context, snapshot) {
            if (snapshot.hasError) {
                return Text(snapshot.error.toString());
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
            }

            print("Here is the data: ${snapshot.data}");
            // print("asdf: ${snapshot.data?.key}");
            // print("qwer: ${snapshot.data?.value}");
            if (snapshot.data != null) {
                _singleton.userData = snapshot.data;
                _singleton.accountType = snapshot.data?.child("accountType").value as String;
                print("user is a ${_singleton.accountType}");
            }

            return const HomeScreen(credential: null);
        })
    );
  }
}