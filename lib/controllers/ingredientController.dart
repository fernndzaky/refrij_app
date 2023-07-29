import 'dart:convert';

import 'package:http/http.dart' as http;

import 'authController.dart';

class IngredientController {
  AuthController authController = AuthController();

  Future getRecommendation(
      List ingredients, String course, String cuisine) async {
    const _url =
        'https://web-production-55b9.up.railway.app/recommend-recipes'; // Replace with the URL of your Python Flask API
    var response = await http.post(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'ingredients': ingredients, // Pass the relevant data to the Flask API
          'course': course, // Pass the relevant data to the Flask API
          'cuisine': cuisine, // Pass the relevant data to the Flask API
        },
      ),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }

  Future<dynamic> getIngredients(int refrigerator_id) async {
    var token = await AuthController.getUserToken();
    String _url =
        'https://refrij-be-go-production.up.railway.app/api/getIngredients/' +
            refrigerator_id.toString();
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

  Future<dynamic> getAllIngredients(int user_id) async {
    var token = await AuthController.getUserToken();
    String _url =
        'https://refrij-be-go-production.up.railway.app/api/getAllUserIngredients/' +
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

  Future<bool> hasExpiringIngredientsTomorrow(int user_id) async {
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));

    try {
      var result = await getAllIngredients(user_id);
      var ingredients = result["content"];

      for (var i in ingredients) {
        String expirationDateString = i['ValidUntil'].toString();
        DateTime expirationDate = DateTime.parse(expirationDateString);

        if (expirationDate.year == tomorrow.year &&
            expirationDate.month == tomorrow.month &&
            expirationDate.day == tomorrow.day) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error fetching ingredients: $e');
      return false;
    }
  }

  Future<dynamic> getAllIngredientsByFilter(int user_id, String value) async {
    var token = await AuthController.getUserToken();
    String _url =
        'https://refrij-be-go-production.up.railway.app/api/getAllUserIngredientsByFilter/' +
            user_id.toString();

    var response = await http.post(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'CategoryName': value,
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

  Future createIngredient(int RefrigeratorID, int UserID, String IngredientName,
      String Quantity, String ValidUntil, String CategoryName) async {
    var token = await AuthController.getUserToken();

    const _url =
        'https://refrij-be-go-production.up.railway.app/api/createIngredient';
    var response = await http.post(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'RefrigeratorID': RefrigeratorID,
          'UserID': UserID,
          'IngredientName': IngredientName,
          'Quantity': Quantity,
          'ValidUntil': ValidUntil,
          'CategoryName': CategoryName,
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

  Future getIngredientDetail(String ingredient_id) async {
    var token = await AuthController.getUserToken();
    String _url =
        'https://refrij-be-go-production.up.railway.app/api/getIngredientDetail/' +
            ingredient_id;

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

  Future updateIngredient(String ingredient_id, String IngredientName,
      String Quantity, String ValidUntil, String CategoryName) async {
    var token = await AuthController.getUserToken();

    String _url =
        'https://refrij-be-go-production.up.railway.app/api/updateIngredient/' +
            ingredient_id;
    var response = await http.put(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'IngredientName': IngredientName,
          'Quantity': Quantity,
          'ValidUntil': ValidUntil,
          'CategoryName': CategoryName,
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

  Future deleteIngredient(String ingredient_id) async {
    var token = await AuthController.getUserToken();

    String _url =
        'https://refrij-be-go-production.up.railway.app/api/deleteIngredient/' +
            ingredient_id;

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

  Future getUserIngredients(String user_id) async {
    var token = await AuthController.getUserToken();
    String _url =
        'https://refrij-be-go-production.up.railway.app/api/getUserIngredients/' +
            user_id;

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
}
