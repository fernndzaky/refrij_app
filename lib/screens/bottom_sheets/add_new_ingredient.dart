import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:refrij_app/components/buttons/white_button.dart';
import 'package:refrij_app/components/inputs/date_text_field.dart';
import 'package:refrij_app/components/inputs/normal_text_field.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../controllers/authController.dart';
import '../../controllers/ingredientController.dart';

class NewIngredientBS extends StatefulWidget {
  final int? param;
  NewIngredientBS({this.param});

  @override
  State<NewIngredientBS> createState() => _NewIngredientBSState();
}

class _NewIngredientBSState extends State<NewIngredientBS> {
  AuthController authController = AuthController();
  IngredientController ingredientController = IngredientController();
  String _formattedDate = "";
  String category = "";
  final nameController = TextEditingController();
  final validController = TextEditingController();
  final quantityController = TextEditingController();
  bool showSpinner = false;
  bool isNameEmpty = false;
  bool isValidEmpty = false;
  bool isQuantityEmpty = false;

  void createIngredient() async {
    setState(() {
      showSpinner = true;
      isNameEmpty = false;
      isValidEmpty = false;
      isQuantityEmpty = false;
    });
    if (nameController.text.isEmpty) {
      setState(() {
        showSpinner = false;
        isNameEmpty = true;
      });
      return;
    }
    if (_formattedDate.isEmpty) {
      setState(() {
        showSpinner = false;
        isValidEmpty = true;
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

    final refrigerator_id = widget.param;

    print('the newly formatted date is ' + _formattedDate);
    final result = await ingredientController.createIngredient(
        refrigerator_id!,
        user_id,
        nameController.text,
        quantityController.text,
        _formattedDate,
        category);

    if (result["success"] == true) {
      setState(() {
        showSpinner = false;
      });
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: "Ingredient has been created!",
        ),
      );
      Navigator.pop(context);

      //Navigator.push(
      //context,
      //MaterialPageRoute(
      //builder: (context) =>
      //RefrigeratorDetailScreen(param: refrigerator_id.toString())),
      //);
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
              'Add New Ingredient',
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
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
              ),
              items: [
                "Vegetables",
                "Proteins",
                "Grains and Cereals",
                'Fruits',
                'Herbs and Spices',
                'Beverages',
                'Others'
              ],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Category",
                  hintText: "Ingredient's Category",
                  labelStyle: TextStyle(
                    fontFamily: 'Rubik Regular',
                    fontSize: 18.0,
                    color: kBrownColor,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: kLightGreyColor), //<-- SEE
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: kLightGreyColor), //<-- SEE
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: kLightGreyColor), //<-- SEE
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
              selectedItem: "Vegetables",
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
              placeholder: 'Ingredient name',
              inputType: 'text',
              initialValue: nameController,
            ),
            SizedBox(
              height: 40.0,
            ),
            if (isValidEmpty == true)
              Text(
                'Please fill in this field',
                style: TextStyle(
                  fontFamily: 'Rubik Medium',
                  fontSize: 14.0,
                  color: Colors.red,
                ),
              ),
            DateTextField(
              initialValue: validController,
              onFieldTapped: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), //get today's date
                    firstDate: DateTime
                        .now(), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  print(
                      pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                  String valueDate = DateFormat('yyyy-MM-dd').format(
                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                  String formattedDate =
                      DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')
                          .format(pickedDate);
                  print(
                      formattedDate); //formatted date output using intl package =>  2022-07-04
                  //You can format date as per your need

                  setState(() {
                    _formattedDate = formattedDate;

                    validController.text =
                        valueDate; //set foratted date to TextField value.
                  });
                } else {
                  print("Date is not selected");
                }
              },
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
            WhiteCircularButton(
              buttonText: showSpinner == true ? 'LOADING.. ' : 'SUBMIT',
              onButtonPressed: () {
                createIngredient();
              },
            ),
          ],
        ),
      ),
    );
  }
}
