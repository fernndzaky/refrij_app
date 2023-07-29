import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refrij_app/components/buttons/white_button.dart';
import 'package:refrij_app/components/inputs/normal_text_field.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controllers/authController.dart';
import '../../controllers/shoppingController.dart';

class NewShoppingItemBS extends StatefulWidget {
  const NewShoppingItemBS({Key? key}) : super(key: key);

  @override
  State<NewShoppingItemBS> createState() => _NewShoppingItemBSState();
}

class _NewShoppingItemBSState extends State<NewShoppingItemBS> {
  AuthController authController = AuthController();
  ShoppingController shoppingController = ShoppingController();
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final noteController = TextEditingController();
  bool showSpinner = false;
  bool isNameEmpty = false;
  bool isQuantityEmpty = false;

  void createShoppingItem() async {
    setState(() {
      showSpinner = true;
      isNameEmpty = false;
      isQuantityEmpty = false;
    });
    if (nameController.text.isEmpty) {
      setState(() {
        showSpinner = false;
        isNameEmpty = true;
      });
      return;
    }

    if (quantityController.text.isEmpty) {
      setState(() {
        showSpinner = false;
        isQuantityEmpty = true;
      });
      return;
    }

    final user_id = await AuthController.getUserID();

    final result = await shoppingController.createShoppingItem(user_id,
        nameController.text, quantityController.text, noteController.text);
    if (result["success"] == true) {
      setState(() {
        showSpinner = false;
      });
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: "Item has been created!",
        ),
      );
      Navigator.pop(context);

      //Navigator.of(context)
      //.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
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
              'Add New Shopping Item',
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
              placeholder: 'Item Name',
              inputType: 'text',
              initialValue: nameController,
            ),
            SizedBox(
              height: 40.0,
            ),
            if (isQuantityEmpty == true)
              Text(
                'Please fill in this field',
                style: TextStyle(
                  fontFamily: 'Rubik Medium',
                  fontSize: 14.0,
                  color: Colors.red,
                ),
              ),
            InputText(
              icon: FontAwesomeIcons.plusMinus,
              placeholder: 'Quantity',
              inputType: 'text',
              initialValue: quantityController,
            ),
            SizedBox(
              height: 40.0,
            ),
            InputText(
              icon: FontAwesomeIcons.noteSticky,
              placeholder: 'Notes',
              inputType: 'text',
              initialValue: noteController,
            ),
            SizedBox(
              height: 40.0,
            ),
            WhiteCircularButton(
              buttonText: showSpinner == true ? 'LOADING.. ' : 'SUBMIT',
              onButtonPressed: () {
                createShoppingItem();
              },
            ),
          ],
        ),
      ),
    );
  }
}
