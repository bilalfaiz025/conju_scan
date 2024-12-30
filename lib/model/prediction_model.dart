class PredictionModel {
  String? predictedClass;
  double? confidence;

  PredictionModel({this.predictedClass, this.confidence});

  PredictionModel.fromJson(Map<String, dynamic> json) {
    predictedClass = json['predicted_class'];
    confidence = json['confidence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['predicted_class'] = predictedClass;
    data['confidence'] = confidence;
    return data;
  }
}