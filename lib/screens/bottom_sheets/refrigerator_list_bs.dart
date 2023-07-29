import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refrij_app/components/buttons/white_button.dart';
import 'package:refrij_app/components/inputs/normal_text_field.dart';
import 'package:refrij_app/controllers/refrigeratorController.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controllers/authController.dart';

class RefrigeratorListBS extends StatefulWidget {
  const RefrigeratorListBS({Key? key}) : super(key: key);

  @override
  State<RefrigeratorListBS> createState() => _RefrigeratorListBSState();
}

class _RefrigeratorListBSState extends State<RefrigeratorListBS> {
  bool showSpinner = false;

  AuthController authController = AuthController();
  RefrigeratorController refrigeratorController = RefrigeratorController();
  final nameController = TextEditingController();
  bool isNameEmpty = false;

  void createRefrigerator() async {
    setState(() {
      showSpinner = true;
    });
    if (nameController.text.isEmpty) {
      setState(() {
        showSpinner = false;
        isNameEmpty = true;
      });
      return;
    }
    final user_id = await AuthController.getUserID();

    final result = await refrigeratorController.createRefrigerator(
      nameController.text,
      user_id,
    );

    print(result);

    if (result["success"] == true) {
      setState(() {
        showSpinner = false;
      });
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: "Refrigerator has been created!",
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF757575),
      child: Container(
        padding:
            EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0, bottom: 80.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.xmark,
                  color: kBlackColor,
                  size: 30.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Add New Refrigerator',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rubik Medium',
                fontSize: 24.0,
                color: kBrownColor,
              ),
            ),
            SizedBox(
              height: 30.0,
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
              icon: FontAwesomeIcons.list,
              placeholder: 'New refrigerator name',
              inputType: 'text',
              initialValue: nameController,
            ),
            SizedBox(
              height: 40.0,
            ),
            WhiteCircularButton(
              buttonText: showSpinner == true ? 'LOADING..' : 'SUBMIT',
              onButtonPressed: () async {
                try {
                  createRefrigerator();
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
