import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refrij_app/utilities/constants.dart';

class DateTextField extends StatefulWidget {
  TextEditingController? initialValue;
  void Function()? onFieldTapped;

  DateTextField({this.initialValue, this.onFieldTapped});

  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.initialValue, //editing controller of this TextField
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15),
        prefixIcon: Icon(
          FontAwesomeIcons.calendar,
          color: kLightGreyColor,
          size: 18.0,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: kLightGreyColor), //<-- SEE
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: kLightGreyColor), //<-- SEE
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 2, color: kLightGreyColor), //<-- SEE
        ),
        hintText: 'Valid Until',
        hintStyle: TextStyle(color: kLightGreyColor),
      ),
      readOnly: true, // when true user cannot edit text
      onTap: widget.onFieldTapped,
    );
  }
}
