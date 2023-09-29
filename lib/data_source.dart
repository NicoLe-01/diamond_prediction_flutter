class Prediction {
  final double carat;
  final double cut;
  final double x;
  final double y;
  final double z;
  final double price;

  Prediction({
    required this.carat,
    required this.cut,
    required this.x,
    required this.y,
    required this.z,
    required this.price,
  });
}

class PredictionDataSource {
  // Simulated list of predictions, replace with your database logic.
  static List<Prediction> getPredictionHistory() {
    return [
      Prediction(carat: 0.5, cut: 1.0, x: 1.0, y: 1.0, z: 1.0, price: 2000),
      Prediction(carat: 0.7, cut: 0.8, x: 1.2, y: 1.1, z: 1.3, price: 3500),
      Prediction(carat: 0.8, cut: 0.1, x: 1.2, y: 1.1, z: 1.3, price: 1500),
      // Add more predictions here.
    ];
  }
}
