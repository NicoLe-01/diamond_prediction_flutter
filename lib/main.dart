import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:testing_app/history_screen.dart';
import 'package:testing_app/login_page.dart';

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
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
    _children = [
      InputField(
        caratController: _caratController,
        cutController: _cutController,
        xController: _xController,
        yController: _yController,
        zController: _zController,
        makePredictions: makePredictions,
        predictionResult: _predictionResult,
      ),
      HistoryScreen(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
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
        _predicting = false;
      });
    } else {
      print('Prediction failed');
      setState(() {
        _predicting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diamond Prediction'),
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
      body: IndexedStack(index: _currentIndex, children: _children),
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
}

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.caratController,
    required this.cutController,
    required this.xController,
    required this.yController,
    required this.zController,
    required this.makePredictions,
    required this.predictionResult,
  }) : super(key: key);

  final TextEditingController caratController;
  final TextEditingController cutController;
  final TextEditingController xController;
  final TextEditingController yController;
  final TextEditingController zController;
  final VoidCallback makePredictions;
  final double predictionResult;

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
              controller: caratController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Carat'),
            ),
            TextFormField(
              controller: cutController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cut'),
            ),
            TextFormField(
              controller: xController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'X'),
            ),
            TextFormField(
              controller: yController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Y'),
            ),
            TextFormField(
              controller: zController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Z'),
            ),
            ElevatedButton(
              onPressed: makePredictions,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16.0),
            Builder(
              builder: (context) {
                return Text(
                  'Hasil Prediksi : $predictionResult',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
