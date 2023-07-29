import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:refrij_app/components/appbars/white_appbar.dart';
import 'package:refrij_app/components/bottom_navigation_bar.dart';
import 'package:refrij_app/components/buttons/white_button.dart';
import 'package:refrij_app/components/inputs/normal_text_field.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/authController.dart';

class SettingsPageScreen extends StatefulWidget {
  const SettingsPageScreen({Key? key}) : super(key: key);

  @override
  State<SettingsPageScreen> createState() => _SettingsPageScreenState();
}

class _SettingsPageScreenState extends State<SettingsPageScreen> {
  AuthController authController = AuthController();

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool isNameEmpty = false;
  bool isEmailEmpty = false;
  bool showSpinner = false;

  void updateUser() async {
    setState(() {
      showSpinner = true;
      isNameEmpty = false;
      isEmailEmpty = false;
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
    final user_id = await AuthController.getUserID();

    final result = await authController.updateUser(
        user_id.toString(), nameController.text, emailController.text);
    if (result["success"] == true) {
      setState(() {
        emailController.text = result["content"]["Email"];
        nameController.text = result["content"]["Name"];
      });
      final snackBar = SnackBar(
        content: Text("Update Success"),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(result["errorMessage"]),
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
  }

  void logoutUser() async {
    setState(() {
      showSpinner = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('email');
    await prefs.remove('name');
    await prefs.remove('token');
    await prefs.setInt("isLoggedIn", 0);

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  getUserDetail() async {
    setState(() {
      showSpinner = true;
    });
    final result = await authController.getClientDashboardDetails();
    setState(() {
      emailController.text = result["content"]["Email"];
      nameController.text = result["content"]["Name"];
      showSpinner = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WhiteAppBar(
        appBarText: "Settings",
      ),
      bottomNavigationBar: StickyBottomNavigationBar(),
      body: ModalProgressHUD(
        opacity: 0.0,
        color: kBrownColor,
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: 40.0, bottom: 40.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Your Profile',
                      style: TextStyle(
                        fontFamily: 'Rubik Medium',
                        fontSize: 24.0,
                        color: kBlackColor,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
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
                      placeholder: 'Email',
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
                      placeholder: 'Full Name',
                      inputType: 'text',
                      initialValue: nameController,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    WhiteCircularButton(
                        buttonText: 'UPDATE MY PROFILE',
                        onButtonPressed: () {
                          updateUser();
                        }),
                  ],
                ),
              ),
              Divider(
                color: kLightGreyColor,
                thickness: 1.0,
              ),
              ListTile(
                horizontalTitleGap: 2.0,
                onTap: () {
                  Navigator.pushNamed(context, '/forgot_password');
                },
                contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                title: Text(
                  'Change Password',
                  style: TextStyle(
                    fontFamily: 'Rubik Medium',
                    fontSize: 18.0,
                    color: kBlackColor,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.lock,
                  color: kBrownColor,
                  size: 18.0,
                ),
              ),
              Divider(
                color: kLightGreyColor,
                thickness: 1.0,
              ),
              ListTile(
                horizontalTitleGap: 2.0,
                onTap: () {
                  logoutUser();
                },
                contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Rubik Medium',
                    fontSize: 18.0,
                    color: kBlackColor,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  color: kBrownColor,
                  size: 18.0,
                ),
              ),
              Divider(
                color: kLightGreyColor,
                thickness: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
