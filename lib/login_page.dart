import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/home_page.dart';
import 'package:testing_app/register_page.dart';
import 'components/my_button.dart';
import 'components/text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      // User is signed in.
      // You can navigate to the HomeScreen or any other authenticated page.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Icon(
                  Icons.diamond,
                  size: 150,
                  color: Color.fromARGB(255, 7, 75, 212),
                ),
                SizedBox(height: 10),
                Text(
                  "Diamond Prediction",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: usernameController,
                  hintText: "Username",
                  obscureText: false,
                ),
                SizedBox(
                  height: 25,
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                SizedBox(
                  height: 30,
                ),
                MyButton(
                  onTap: () {
                    signIn(context);
                  },
                ),
                SizedBox(height: 8,),
                RichText(
                  text: TextSpan(
                    text: 'Not have an account? Click ',
                    style: TextStyle(color: Colors.black45),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'here',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
      ),
    ],
  ),
)

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
