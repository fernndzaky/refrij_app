import 'dart:convert';

import 'package:http/http.dart' as http;

import 'authController.dart';

class ShoppingController {
  AuthController authController = AuthController();

  Future<dynamic> getShoppingItems(int user_id) async {
    var token = await AuthController.getUserToken();
    String _url =
        'https://refrij-be-go-production.up.railway.app/api/getShoppingItems/' +
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

  Future getShoppingItemDetail(String item_id) async {
    var token = await AuthController.getUserToken();
    String _url =
        'https://refrij-be-go-production.up.railway.app/api/getShoppingItemDetail/' +
            item_id;

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

  Future deleteShoppingItem(String item_id) async {
    var token = await AuthController.getUserToken();

    String _url =
        'https://refrij-be-go-production.up.railway.app/api/deleteShoppingItem/' +
            item_id;

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

  Future updateShoppingItem(
      String item_id, String ItemName, String Quantity, String Note) async {
    var token = await AuthController.getUserToken();

    String _url =
        'https://refrij-be-go-production.up.railway.app/api/updateShoppingItem/' +
            item_id;
    var response = await http.put(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'ItemName': ItemName,
          'Quantity': Quantity,
          'Note': Note,
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

  Future updateCheckBoxState(String item_id, bool checkBoxValue) async {
    var token = await AuthController.getUserToken();

    String _url =
        'https://refrij-be-go-production.up.railway.app/api/updateIsBought/' +
            item_id;
    var response = await http.put(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'IsBought': checkBoxValue,
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

  Future createShoppingItem(
    int UserID,
    String ItemName,
    String Quantity,
    String Note,
  ) async {
    var token = await AuthController.getUserToken();

    const _url =
        'https://refrij-be-go-production.up.railway.app/api/createShoppingItem';
    var response = await http.post(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'UserID': UserID,
          'ItemName': ItemName,
          'Quantity': Quantity,
          'Note': Note,
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
