import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refrij_app/utilities/constants.dart';

class InputText extends StatefulWidget {
  final IconData? icon;
  final String? placeholder;
  final String? inputType;
  final bool? isEnabled;
  TextEditingController? initialValue;
  bool _passwordVisible = false;

  InputText(
      {this.icon,
      this.placeholder,
      this.inputType,
      this.isEnabled = true,
      this.initialValue});

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 18, fontFamily: 'Rubik Regular'),
      controller: widget.initialValue,
      keyboardType: widget.inputType == 'number'
          ? TextInputType.phone
          : widget.inputType == 'email'
              ? TextInputType.emailAddress
              : TextInputType.text,
      obscureText:
          (widget.inputType == 'password' && !widget._passwordVisible) && true,
      enabled: widget.isEnabled,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.isEnabled == true ? Colors.white : Color(0xFFDADADA),
        contentPadding: EdgeInsets.symmetric(vertical: 15),
        prefixIcon: Icon(
          widget.icon,
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
        hintText: widget.placeholder,
        hintStyle: TextStyle(color: kLightGreyColor),
        suffixIcon: widget.inputType == 'password'
            ? IconButton(
                icon: Icon(
                  widget._passwordVisible
                      ? FontAwesomeIcons.eyeSlash
                      : FontAwesomeIcons.eye,
                  color: kLightGreyColor,
                  size: 18.0,
                ),
                onPressed: () {
                  setState(() {
                    widget._passwordVisible = !widget._passwordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}
