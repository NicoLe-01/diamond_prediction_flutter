import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<QueryDocumentSnapshot>> getPredictionHistory() async {
  final QuerySnapshot predictionSnapshot =
      await FirebaseFirestore.instance.collection('predictions').get();
  return predictionSnapshot.docs;
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text('Please log in to see your prediction'),
      );
    }

    CollectionReference userPredictions = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('predictions');

    return StreamBuilder<QuerySnapshot>(
      stream: userPredictions
          .snapshots(), // Use the Firestore data retrieval method
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No prediction history available.'));
        } else {
          final predictions = snapshot.data!.docs;
          return ListView.builder(
            itemCount: predictions.length,
            itemBuilder: (context, index) {
              final prediction = predictions[index];
              final data = prediction.data() as Map<String, dynamic>;
              return ListTile(
                horizontalTitleGap: 1.0,
                leading: Container(
                    padding: EdgeInsets.only(left: 3),
                    margin: EdgeInsets.only(top: 7),
                    child: Icon(Icons.article,)),
                title: Text('Carat: ${data['carat'].toStringAsFixed(2)}'),
                subtitle: Text('Price: \$ ${data['price'].toStringAsFixed(2)}'),
              );
            },
          );
        }
      },
    );
  }
}
