// ignore_for_file: avoid_print

import 'package:conju_app/model/prediction_model.dart';
import 'package:conju_app/services/network/network_class.dart';
import 'package:conju_app/services/network/service_class.dart';
import 'package:flutter/material.dart';

class PredictionViewModel extends ChangeNotifier {
  List<PredictionModel> _modelData = [];
  List<PredictionModel> get modelData => _modelData;
  setPredictionData(List<PredictionModel> data) {
    clearPredictionData();
    _modelData = data;
    notifyListeners();
  }

  clearPredictionData() {
    _modelData.clear();
    modelData.clear();
    notifyListeners();
  }

  Future<void> getPredictData(String imagePath) async {
    final response = await PredictionService.uploadImage(imagePath);
    if (response is Success) {
      setPredictionData(response.response as List<PredictionModel>);
    } else if (response is Failure) {
      // Handle failure
      print('Error: ${response.response}');
    } else {
      // Handle unexpected response type
      print('Unexpected response type');
    }
  }
}
