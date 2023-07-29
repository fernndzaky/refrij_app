import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WhiteBackButton extends StatelessWidget {
  const WhiteBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        FontAwesomeIcons.angleLeft,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
