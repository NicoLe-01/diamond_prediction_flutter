import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_app/components/form_field.dart';
import 'package:testing_app/components/text_field.dart';
import 'package:testing_app/history_screen.dart';
import 'package:testing_app/login_page.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _caratController = TextEditingController();
  final TextEditingController _cutController = TextEditingController();
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();
  final TextEditingController _zController = TextEditingController();

  double _predictionResult = 0.0;

  int _currentIndex = 0;
  bool _predicting = false;

  late List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> storePrediction(double carat, double cut, double x, double y,
      double z, double price) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final CollectionReference userCollections =
        FirebaseFirestore.instance.collection('users').doc(user.uid).collection('predictions');

    await userCollections.add({
      'carat': carat,
      'cut': cut,
      'x': x,
      'y': y,
      'z': z,
      'price': price,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  bool validateUserInput() {
    // Implement your validation logic here
    // You can check if the user input is in the expected range, format, etc.
    // Return true if the input is valid, otherwise, return false and show an error.
    return true;
  }

  void showError(String errorMessage) {
    // Implement how you want to display error messages to the user (e.g., a snackbar).
  }

  void clearInputFields() {
    // Clear the input fields after a successful prediction.
    _caratController.clear();
    _cutController.clear();
    _xController.clear();
    _yController.clear();
    _zController.clear();
  }

  Future<void> makePredictions() async {
    if (!validateUserInput()) {
      return;
    }

    setState(() {
      _predicting = true;
    });

    double carat = double.tryParse(_caratController.text) ?? 0.0;
    double cut = double.tryParse(_cutController.text) ?? 0.0;
    double x = double.tryParse(_xController.text) ?? 0.0;
    double y = double.tryParse(_yController.text) ?? 0.0;
    double z = double.tryParse(_zController.text) ?? 0.0;

    final apiUrl = Uri.parse('http://10.0.2.2:5000/predict');

    try {
      final response = await http.post(
        apiUrl,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({'carat': carat, 'cut': cut, 'x': x, 'y': y, 'z': z}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final predictionResult = data['prediction'];

        setState(() {
          _predictionResult = predictionResult;
          storePrediction(carat, cut, x, y, z, _predictionResult);
          clearInputFields();
          _predicting = false;
        });
      } else {
        showError("Prediction Failed");
        setState(() {
          _predicting = false;
        });
      }
    } catch (error) {
      showError("An error occoured : $error ");
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    _children = [
      Prediction(),
      const HistoryScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diamond Prediction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: _children.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  SafeArea Prediction() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text("Form Prediciton", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0,),
              buildTextFormField(_caratController, "Carat"),
              const SizedBox(height: 16.0,),
              buildTextFormField(_cutController, 'Cut'),
              const SizedBox(height: 16.0,),
              buildTextFormField(_xController, 'X'),
              const SizedBox(height: 16.0,),
              buildTextFormField(_yController, 'Y'),
              const SizedBox(height: 16.0,),
              buildTextFormField(_zController, 'Z'),
              const SizedBox(height: 16.0,),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    makePredictions();
                  });
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16.0),
              Text(
                "Hasil Prediksi : $_predictionResult",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

}
