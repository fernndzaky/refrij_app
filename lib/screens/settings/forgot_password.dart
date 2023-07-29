import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:refrij_app/components/buttons/white_button.dart';
import 'package:refrij_app/components/inputs/normal_text_field.dart';
import 'package:refrij_app/utilities/constants.dart';

import '../../controllers/authController.dart';

class ForgotPasswordPageScreen extends StatefulWidget {
  const ForgotPasswordPageScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPageScreen> createState() =>
      _ForgotPasswordPageScreenState();
}

class _ForgotPasswordPageScreenState extends State<ForgotPasswordPageScreen> {
  AuthController authController = AuthController();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  bool isOldPasswordEmpty = false;
  bool isNewPasswordEmpty = false;
  bool isConfirmNewPasswordEmpty = false;
  bool showSpinner = false;

  void updatePassword() async {
    setState(() {
      showSpinner = true;
      isOldPasswordEmpty = false;
      isNewPasswordEmpty = false;
      isConfirmNewPasswordEmpty = false;
    });

    if (oldPasswordController.text.isEmpty) {
      setState(() {
        showSpinner = false;
        isOldPasswordEmpty = true;
      });
      return;
    }
    if (newPasswordController.text.isEmpty) {
      setState(() {
        showSpinner = false;
        isNewPasswordEmpty = true;
      });
      return;
    }
    if (confirmNewPasswordController.text.isEmpty) {
      setState(() {
        showSpinner = false;
        isConfirmNewPasswordEmpty = true;
      });
      return;
    }
    final user_id = await AuthController.getUserID();

    final result = await authController.updatePassword(
        user_id.toString(),
        oldPasswordController.text,
        newPasswordController.text,
        confirmNewPasswordController.text);

    print(result);
    if (result["success"] == true) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/settings', (Route<dynamic> route) => false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.angleLeft,
            color: kBlackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ModalProgressHUD(
        opacity: 0.0,
        color: kBrownColor,
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 40.0, left: 20.0, right: 20.0, bottom: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Top Section
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontFamily: 'Rubik Medium',
                          fontSize: 24.0,
                          color: kBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
                //Form Section
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (isOldPasswordEmpty == true)
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
                          placeholder: 'Old Password',
                          inputType: 'password',
                          initialValue: oldPasswordController,
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        if (isNewPasswordEmpty == true)
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
                          placeholder: 'New Password',
                          inputType: 'password',
                          initialValue: newPasswordController,
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        if (isConfirmNewPasswordEmpty == true)
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
                          placeholder: 'Confirm New Password',
                          inputType: 'password',
                          initialValue: confirmNewPasswordController,
                        ),
                        SizedBox(height: 40.0),
                        WhiteCircularButton(
                          buttonText: 'UPDATE MY PASSWORD',
                          onButtonPressed: () {
                            updatePassword();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
