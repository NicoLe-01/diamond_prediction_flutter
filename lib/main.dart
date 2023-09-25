import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Diamond Prediction'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _caratController = TextEditingController();
  final TextEditingController _cutController = TextEditingController();
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();
  final TextEditingController _zController = TextEditingController();

  double _predictionResult = 0.0; // Move it to the top of the class

  Future<void> makePredictions() async {
    double carat = double.tryParse(_caratController.text) ?? 0.0;
    double cut = double.tryParse(_cutController.text) ?? 0.0;
    double x = double.tryParse(_xController.text) ?? 0.0;
    double y = double.tryParse(_yController.text) ?? 0.0;
    double z = double.tryParse(_zController.text) ?? 0.0;

    final apiUrl = Uri.parse('http://10.0.2.2:5000/predict');

    final response = await http.post(
      apiUrl,
      headers: <String, String>{
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'carat': carat, 'cut': cut, 'x': x, 'y': y, 'z': z}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final predictionResult = data['prediction'];

      setState(() {
        _predictionResult = predictionResult;
      });
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: InputField(
          caratController: _caratController,
          cutController: _cutController,
          xController: _xController,
          yController: _yController,
          zController: _zController,
          makePredictions: makePredictions, // Pass the function
          predictionResult: _predictionResult, // Pass the result
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required TextEditingController caratController,
    required TextEditingController cutController,
    required TextEditingController xController,
    required TextEditingController yController,
    required TextEditingController zController,
    required this.makePredictions, // Receive the function
    required this.predictionResult, // Receive the result
  })  : _caratController = caratController,
        _cutController = cutController,
        _xController = xController,
        _yController = yController,
        _zController = zController,
        super(key: key);

  final TextEditingController _caratController;
  final TextEditingController _cutController;
  final TextEditingController _xController;
  final TextEditingController _yController;
  final TextEditingController _zController;
  final VoidCallback makePredictions; // Declare the function
  final double predictionResult; // Declare the result

  @override
  Widget build(BuildContext context) {
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
              onPressed: makePredictions, // Call the makePredictions function
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Hasil Prediksi : $predictionResult', // Display the prediction result here
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
