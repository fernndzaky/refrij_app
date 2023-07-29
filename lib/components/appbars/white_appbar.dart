import 'package:flutter/material.dart';
import 'package:refrij_app/utilities/constants.dart';

class WhiteAppBar extends StatelessWidget with PreferredSizeWidget {
  String appBarText;
  WhiteAppBar({this.appBarText = ""});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: Border(bottom: BorderSide(color: kLightGreyColor, width: 1)),
      title: Text(
        appBarText,
        style: TextStyle(
          fontFamily: 'Rubik Regular',
          fontSize: 20.0,
          color: kBlackColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}
