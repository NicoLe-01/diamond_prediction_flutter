import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    final CollectionReference predictionsCollection =
        FirebaseFirestore.instance.collection('predictions');

    await predictionsCollection.add({
      'carat': carat,
      'cut': cut,
      'x': x,
      'y': y,
      'z': z,
      'price': price,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> makePredictions() async {
    setState(() {
      _predicting = true;
    });

    double carat = double.tryParse(_caratController.text) ?? 0.0;
    double cut = double.tryParse(_cutController.text) ?? 0.0;
    double x = double.tryParse(_xController.text) ?? 0.0;
    double y = double.tryParse(_yController.text) ?? 0.0;
    double z = double.tryParse(_zController.text) ?? 0.0;

    final apiUrl = Uri.parse('http://10.0.2.2:5000/predict');

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
        print('Prediction : $_predictionResult');
        _predicting = false;
      });
    } else {
      print('Prediction failed');
      setState(() {
        _predicting = false;
      });
    }

    storePrediction(carat, cut, x, y, z, _predictionResult);
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

  SingleChildScrollView Prediction() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _caratController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Carat'),
            ),
            TextFormField(
              controller: _cutController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cut'),
            ),
            TextFormField(
              controller: _xController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'X'),
            ),
            TextFormField(
              controller: _yController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Y'),
            ),
            TextFormField(
              controller: _zController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Z'),
            ),
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
    );
  }
}
