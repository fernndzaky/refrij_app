import 'package:flutter/material.dart';
import 'package:refrij_app/utilities/constants.dart';

class PinkAppBar extends StatelessWidget with PreferredSizeWidget {
  const PinkAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: kPinkColor,
      elevation: 0,
      title: Text(
        'Home',
        style: TextStyle(
          fontFamily: 'Rubik Regular',
          fontSize: 20.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}
