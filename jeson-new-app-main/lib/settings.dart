import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'size_config.dart';
import 'authentication.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 54,
              width: SizeConfig.blockSizeHorizontal! * 80,
              child: ElevatedButton(
                onPressed: () {
                  AuthenticationHelper().signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB63E7),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 54,
              width: SizeConfig.blockSizeHorizontal! * 80,
              child: ElevatedButton(
                onPressed: () {
                  _dialogBuilder(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 231, 99, 99),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete your account?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'No',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              width: 20,
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Yes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              onPressed: () async {
                final ref = FirebaseDatabase.instance.reference();
                ref.child(AuthenticationHelper().user!.uid).remove();
                await AuthenticationHelper().user!.delete().then((value) {
                  AuthenticationHelper().signOut();
                  print('Account Deleted');
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                }).catchError((error) {
                  print('Error: $error');
                });

                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
