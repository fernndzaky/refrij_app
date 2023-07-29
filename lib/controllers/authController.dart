import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static Future<String> getUserEmail() async {
    final preferences = await SharedPreferences.getInstance();

    final email = await preferences.getString('email') ?? "Not found";

    return email;
  }

  static Future<String> getUserName() async {
    final preferences = await SharedPreferences.getInstance();

    final name = await preferences.getString('name') ?? "Not found";

    return name;
  }

  static Future<String> getUserToken() async {
    final preferences = await SharedPreferences.getInstance();

    final token = await preferences.getString('token') ?? "Not found";

    return token;
  }

  static Future<dynamic> getUserID() async {
    final preferences = await SharedPreferences.getInstance();

    final user_id = await preferences.getInt('user_id') ?? 0;

    return user_id;
  }

  Future loginUser(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const _url = 'https://refrij-be-go-production.up.railway.app/api/login';
    var response = await http.post(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
        },
      ),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      await prefs.setInt(
          'user_id', json.decode(response.body)["content"]["ID"]);
      await prefs.setString('token', json.decode(response.body)["token"]);
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }

  Future getClientDashboardDetails() async {
    var token = await getUserToken();
    var id = await getUserID();
    var _url =
        'https://refrij-be-go-production.up.railway.app/api/get-user-detail/' +
            id.toString();
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

  static CheckLogin(Function()? logged_in) {
    final user = getUserID();

    if (user != null) {
      // User is logged in, redirect to home screen
      Future.delayed(Duration.zero, logged_in);
    }
  }

  Future registerUser(
    String email,
    String name,
    String password,
  ) async {
    const _url = 'https://refrij-be-go-production.up.railway.app/api/signup';
    var response = await http.post(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'email': email,
          'name': name,
          'password': password,
        },
      ),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  }

  Future updateUser(String user_id, String name, String email) async {
    var token = await AuthController.getUserToken();

    String _url =
        'https://refrij-be-go-production.up.railway.app/api/update/' + user_id;
    var response = await http.put(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'Name': name,
          'Email': email,
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

  Future updatePassword(String user_id, String oldPassword, String newPassword,
      String confirmPassword) async {
    var token = await AuthController.getUserToken();

    String _url =
        'https://refrij-be-go-production.up.railway.app/api/change-password/' +
            user_id;
    var response = await http.put(
      Uri.parse(_url),
      body: jsonEncode(
        {
          'OldPassword': oldPassword,
          'NewPassword': newPassword,
          'ConfirmNewPassword': confirmPassword,
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
