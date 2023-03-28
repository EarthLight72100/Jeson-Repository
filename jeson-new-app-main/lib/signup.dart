import 'package:flutter/material.dart';
import 'package:jeson_flutter_app/size_config.dart';
import 'authentication.dart';
import 'initialization.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 50),
            // logo
            Image.asset('assets/logo.png', height: 150),
            const SizedBox(height: 10),
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignupForm(),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text('Already here?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(' Get Logged in Now!',
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  String? dropdownValue = "Student";
  var items = ["Student", "Instructor"];

  bool _obscureText = false;

  bool agree = false;

  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
    );

    var space = const SizedBox(height: 10);
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // email
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'Email',
                border: border),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),

          space,

          // password
          TextFormField(
            controller: pass,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: border,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            onSaved: (val) {
              password = val;
            },
            obscureText: !_obscureText,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          space,
          // confirm passwords
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: border,
            ),
            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'password not match';
              }
              return null;
            },
          ),
          space,
          // name
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFFAB63E7),
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButton(
                  value: dropdownValue,
                  dropdownColor: const Color(0xFFAB63E7),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  })),

          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Checkbox(
                  onChanged: (_) {
                    setState(() {
                      agree = !agree;
                    });
                  },
                  value: agree,
                ),
              ),
              const Expanded(
                flex: 4,
                child: Text(
                    'By creating account, I agree to Terms & Conditions and Privacy Policy.'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          // signUP button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  AuthenticationHelper()
                      .signUp(
                          email: email!,
                          password: password!,
                          accountType: dropdownValue!)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InitializationScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAB63E7),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
