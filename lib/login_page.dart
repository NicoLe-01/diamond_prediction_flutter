import 'package:flutter/material.dart';
import 'package:testing_app/components/text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Icon(
                Icons.lock,
                size: 100,
              ),
              SizedBox(height: 50),
              Text(
                "welcome",
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
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
