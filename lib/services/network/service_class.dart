import 'dart:convert';
import 'package:conju_app/model/prediction_model.dart';
import 'package:conju_app/services/network/network_class.dart';
import 'package:http/http.dart' as http;

class PredictionService {
  static String apiUrl = "http://192.168.0.105:8000/predict/";
  static Future<dynamic> uploadImage(String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(apiUrl),
    );
    // Get image file from path and add to request
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    // Send request
    try {
      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        String responseBody = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseBody);

        if (decodedResponse is List) {
          List<PredictionModel> modelResponse = decodedResponse
              .map((item) => PredictionModel.fromJson(item))
              .toList();
          return Success(code: 200, response: modelResponse);
        } else if (decodedResponse is Map<String, dynamic>) {
          PredictionModel predictionModel =
              PredictionModel.fromJson(decodedResponse);
          return Success(code: 200, response: [predictionModel]);
        }
      } else {
        String responseBody = await response.stream.bytesToString();
        final decodedBody = json.decode(responseBody);
        return {
          "error": "Failed to predict",
          "message": decodedBody['message'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      return {"error": "Error", "message": e.toString()};
    }
  }
}
