import 'package:flutter/material.dart';
import 'data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<QueryDocumentSnapshot>> getPredictionHistory() async {
  final QuerySnapshot predictionSnapshot =
      await FirebaseFirestore.instance.collection('predictions').get();
  return predictionSnapshot.docs;
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: getPredictionHistory(), // Use the Firestore data retrieval method
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No prediction history available.'));
        } else {
          final predictions = snapshot.data!;
          return ListView.builder(
            itemCount: predictions.length,
            itemBuilder: (context, index) {
              final prediction = predictions[index];
              final data = prediction.data() as Map<String, dynamic>;
              return ListTile(
                leading: Icon(Icons.list),
                title: Text('Carat: ${data['carat'].toStringAsFixed(2)}'),
                subtitle: Text('Price: \$${data['price'].toStringAsFixed(2)}'),
              );
            },
          );
        }
      },
    );
  }
}
