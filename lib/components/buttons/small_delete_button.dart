import 'package:flutter/material.dart';
import 'package:refrij_app/utilities/constants.dart';

class SmallDeleteButton extends StatelessWidget {
  Function()? onButtonPressed;
  Color? textColor;
  String text;
  SmallDeleteButton(
      {this.onButtonPressed, this.textColor, this.text = "DELETE"});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(color: kLightGreyColor, width: 2.0)),
        ),
      ),
      onPressed: onButtonPressed,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Rubik Regular',
          fontSize: 16.0,
          color: textColor,
        ),
      ),
    );
  }
}
