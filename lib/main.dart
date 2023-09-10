import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Diamond Prediction'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double _carat = 0.0;
  final TextEditingController _caratController = TextEditingController();

  final double _cut = 0.0;
  final TextEditingController _cutController = TextEditingController();

  final double _x = 0.0;
  final TextEditingController _xController = TextEditingController();

  final double _y = 0.0;
  final TextEditingController _yController = TextEditingController();

  final double _z = 0.0;
  final TextEditingController _zController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required TextEditingController caratController,
    required TextEditingController cutController,
    required TextEditingController xController,
    required TextEditingController yController,
    required TextEditingController zController,
  })  : _caratController = caratController,
        _cutController = cutController,
        _xController = xController,
        _yController = yController,
        _zController = zController;

  final TextEditingController _caratController;
  final TextEditingController _cutController;
  final TextEditingController _xController;
  final TextEditingController _yController;
  final TextEditingController _zController;

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
            // Add the submit button here
            const ElevatedButton(
              onPressed: null,
              child: Text('Submit'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Prediction Result:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "0", // Display the prediction result here
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
