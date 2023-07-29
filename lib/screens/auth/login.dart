import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:refrij_app/components/buttons/brown_button.dart';
import 'package:refrij_app/components/buttons/white_button.dart';
import 'package:refrij_app/components/inputs/normal_text_field.dart';
import 'package:refrij_app/controllers/authController.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = AuthController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showSpinner = false;
  bool isEmailEmpty = false;
  bool isPasswordEmpty = false;
  String errorMessage = "";

  Future<bool> isUserLoggedIn() async {
    print('checking...');

    if (await AuthController.getUserToken() == 'Not found') {
      print('not found');
      return false;
    } else {
      return true;
    }
  }

  static CheckLogin(Function()? logged_in) async {
    final preferences = await SharedPreferences.getInstance();

    final user_id = await preferences.getInt('user_id') ?? 0;

    if (user_id != 0) {
      print("the user is logged in");
      // User is logged in, redirect to home screen
      Future.delayed(Duration.zero, logged_in);
      return;
    }
  }

  void loginUser() async {
    try {
      setState(() {
        showSpinner = true;
        isEmailEmpty = false;
        isPasswordEmpty = false;
        errorMessage = "";
      });

      if (emailController.text.isEmpty) {
        setState(() {
          showSpinner = false;
          isEmailEmpty = true;
        });
        return;
      }

      if (passwordController.text.isEmpty) {
        setState(() {
          showSpinner = false;
          isPasswordEmpty = true;
        });
        return;
      }

      final result = await authController.loginUser(
          emailController.text, passwordController.text);
      if (result["success"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("isLoggedIn", 1);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      } else {
        setState(() {
          errorMessage = result["errorMessage"];
        });
        final snackBar = SnackBar(
          content: Text(errorMessage),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    CheckLogin(() {
      Navigator.pushReplacementNamed(context, '/home');
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: WhiteCircularButton(
          buttonText: 'OOPS.. I DO ONT HAVE AN ACCOUNT',
          onButtonPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ModalProgressHUD(
        opacity: 0.0,
        color: kBrownColor,
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //TOP SECTION
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to Refrij!',
                          style: TextStyle(
                            fontFamily: 'Rubik Medium',
                            fontSize: 24.0,
                            color: kBlackColor,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Enter your credentials to continue',
                          style: TextStyle(
                            fontFamily: 'Rubik Regular',
                            fontSize: 16.0,
                            color: kLightGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //CENTER SECTION
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.15),
                    child: Column(
                      children: <Widget>[
                        if (isEmailEmpty == true)
                          Text(
                            'Please fill in this field',
                            style: TextStyle(
                              fontFamily: 'Rubik Medium',
                              fontSize: 14.0,
                              color: Colors.red,
                            ),
                          ),
                        InputText(
                          icon: FontAwesomeIcons.solidEnvelope,
                          placeholder: 'Insert your email',
                          inputType: 'email',
                          initialValue: emailController,
                        ),
                        SizedBox(height: 40.0),
                        if (isPasswordEmpty == true)
                          Text(
                            'Please fill in this field',
                            style: TextStyle(
                              fontFamily: 'Rubik Medium',
                              fontSize: 14.0,
                              color: Colors.red,
                            ),
                          ),
                        InputText(
                          icon: FontAwesomeIcons.lock,
                          placeholder: '*********',
                          inputType: 'password',
                          initialValue: passwordController,
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        BrownCircularButton(
                          buttonText: 'LOGIN',
                          onButtonPressed: () {
                            loginUser();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
