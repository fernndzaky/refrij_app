import 'package:flutter/material.dart';
import 'package:refrij_app/utilities/constants.dart';

class WhiteCircularButton extends StatelessWidget {
  String buttonText;
  void Function()? onButtonPressed;

  WhiteCircularButton({@required this.buttonText = "", this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 20.0)),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                side: BorderSide(color: kLightGreyColor, width: 2.0)),
          ),
        ),
        onPressed: onButtonPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontFamily: 'Rubik Regular',
            fontSize: 16.0,
            color: kBlackColor,
          ),
        ),
      ),
    );
  }
}
