import 'package:flutter/material.dart';
import 'authentication.dart';
import 'loading.dart';
import 'size_config.dart';
import 'login.dart';
import 'home.dart';

class Checker extends StatelessWidget {
  const Checker({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder(
        stream: AuthenticationHelper().userstream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // loading state
            return const LoadingScreen();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            // if the user is already logged in
            // return const Home();
            // AuthenticationHelper().updateData();
            return const RandomWords(credential: null); // centual page
          } else {
            return Login();
          }
        });
  }
}
