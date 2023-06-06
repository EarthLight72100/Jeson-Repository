//Code Provided by https://www.bacancytechnology.com/blog/email-authentication-using-firebase-auth-and-flutter
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userstream = FirebaseAuth.instance.authStateChanges();

  get user => _auth.currentUser;
  get uid => user.uid;

  //creates a new user with email and password
  Future signUp(
      {required String email,
      required String password,
      required String accountType}) async {
    //print(uid);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      DatabaseReference mDatabase = FirebaseDatabase.instance.ref();
      mDatabase.child("users/${user.uid}").update({"accountType": accountType});
      //  mDatabase.child("users").child(user.uid).set("hello world");
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  String getUID() {
    return user.uid;
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // print(uid);
      // print(email);
      // print(password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }

  Future instructorCheck() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("instructorPasscode").get();
    if (snapshot.exists) {
      print(snapshot.value);
      return snapshot.value.toString();
    } else {
      print("No instructor password exists.");
      return null;
    }
  }
}
