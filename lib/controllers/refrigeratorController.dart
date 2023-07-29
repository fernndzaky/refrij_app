import 'dart:convert';

import 'package:http/http.dart' as http;

import 'authController.dart';

class RefrigeratorController {
  AuthController authController = AuthController();

  Future getRefrigeratorDetail(String refrigerator_id) async {
    var token = await AuthController.getUserToken();
    String _url =
        'https://refrij-be-go-production.up.railway.app/api/getRefrigeratorDetail/' +
            refrigerator_id;
    var response = await http.get(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
    }
  }

  Future<dynamic> getRefrigerators(int user_id) async {
    var token = await AuthController.getUserToken();
    String _url =
        'https://refrij-be-go-production.up.railway.app/api/getRefiregators/' +
            user_id.toString();
    var response = await http.get(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }

  Future deleteRefigerator(String refrigerator_id) async {
    var token = await AuthController.getUserToken();

    String _url =
        'https://refrij-be-go-production.up.railway.app/api/deleteRefrigerator/' +
            refrigerator_id;

    var response = await http.delete(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }

  Future createRefrigerator(
    String RefrigeratorName,
    int UserID,
  ) async {
    var token = await AuthController.getUserToken();

    const _url =
        'https://refrij-be-go-production.up.railway.app/api/createRefrigerator';
    var response = await http.post(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'RefrigeratorName': RefrigeratorName,
          'UserID': UserID,
        },
      ),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }
}
