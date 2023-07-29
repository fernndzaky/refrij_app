import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:refrij_app/components/inputs/normal_text_field.dart';
import 'package:refrij_app/controllers/authController.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/buttons/pink_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showSpinner = false;
  bool isChecked = false;
  AuthController authController = AuthController();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isEmailEmpty = false;
  bool isNameEmpty = false;
  bool isPasswordEmpty = false;
  bool isBoolNotCheked = false;
  String errorMessage = "";

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

  Future<bool> isUserLoggedIn() async {
    if (await AuthController.getUserToken() == 'Not found') {
      print('not found');
      return false;
    } else {
      return true;
    }
  }

  void registerUser() async {
    try {
      setState(() {
        showSpinner = true;
        isNameEmpty = false;
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
      if (nameController.text.isEmpty) {
        setState(() {
          showSpinner = false;
          isNameEmpty = true;
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

      final result = await authController.registerUser(
        emailController.text,
        nameController.text,
        passwordController.text,
      );

      if (result["success"] == true) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      } else {
        setState(() {
          errorMessage = result["errorMessage"];
        });
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
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.angleLeft,
              color: kBrownColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ModalProgressHUD(
          opacity: 0.0,
          color: kPinkColor,
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 50.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Top Section
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          'Hello there!',
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
                          'Sign up here to get started',
                          style: TextStyle(
                            fontFamily: 'Rubik Regular',
                            fontSize: 16.0,
                            color: kLightGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Form Section
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(
                          height: 40.0,
                        ),
                        if (isNameEmpty == true)
                          Text(
                            'Please fill in this field',
                            style: TextStyle(
                              fontFamily: 'Rubik Medium',
                              fontSize: 14.0,
                              color: Colors.red,
                            ),
                          ),
                        InputText(
                          icon: FontAwesomeIcons.solidUser,
                          placeholder: 'Insert your full name',
                          inputType: 'text',
                          initialValue: nameController,
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
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
                          placeholder: 'Insert your password',
                          inputType: 'password',
                          initialValue: passwordController,
                        ),
                        SizedBox(height: 30.0),
                        if (isBoolNotCheked == true)
                          Text(
                            'Please check this box',
                            style: TextStyle(
                              fontFamily: 'Rubik Medium',
                              fontSize: 14.0,
                              color: Colors.red,
                            ),
                          ),
                        ListTile(
                          onLongPress: null,
                          contentPadding: EdgeInsets.all(0.0),
                          title: InkWell(
                              child: RichText(
                                text: new TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'I accept the ',
                                      style: TextStyle(
                                        fontFamily: 'Dosis Regular',
                                        fontSize: 16.0,
                                        color: kBlackColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'terms & conditions',
                                      style: TextStyle(
                                        fontFamily: 'Dosis Bold',
                                        fontSize: 16.0,
                                        color: kPinkColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/terms_and_conditions');
                              }),
                          trailing: Checkbox(
                            activeColor: kPinkColor,
                            value: isChecked,
                            onChanged: (test) {
                              if (isChecked == true) {
                                setState(() {
                                  isChecked = false;
                                });
                              } else {
                                setState(() {
                                  isChecked = true;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        PinkCircularButton(
                          buttonText: 'SIGN ME UP',
                          onButtonPressed: () {
                            registerUser();
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
