import 'package:flutter/material.dart';
import 'data_source.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final predictions = PredictionDataSource.getPredictionHistory();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: predictions.isEmpty
          ? Center(
              child: Text('No prediction history available.'),
            )
          : ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                final prediction = predictions[index];
                return ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Carat: ${prediction.carat.toString()}'),
                  subtitle:
                      Text('Price: \$${prediction.price.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
}
