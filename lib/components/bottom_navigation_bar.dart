import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refrij_app/utilities/constants.dart';

class StickyBottomNavigationBar extends StatefulWidget {
  const StickyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _StickyBottomNavigationBarState createState() =>
      _StickyBottomNavigationBarState();
}

class _StickyBottomNavigationBarState extends State<StickyBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    var route = ModalRoute.of(context);
    if (route != null) {
      if (index == 0 && route.settings.name != '/home') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      } else if (index == 1 && route.settings.name != '/refrigerators') {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/refrigerators', (Route<dynamic> route) => false);
      } else if (index == 2 && route.settings.name != '/ingredients') {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/ingredients', (Route<dynamic> route) => false);
      } else if (index == 3 && route.settings.name != '/settings') {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/settings', (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);
    if (route != null) {
      if ((route.settings.name == '/refrigerators') |
          (route.settings.name == '/refrigeratorDetail')) {
        _selectedIndex = 1;
      } else if (route.settings.name == '/ingredients') {
        _selectedIndex = 2;
      } else if (route.settings.name == '/settings') {
        _selectedIndex = 3;
      } else {
        _selectedIndex = 0;
      }
    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(color: Color(0xFFD4D4D4), width: 2.0))),
      child: BottomNavigationBar(
        iconSize: 20.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.house,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.list,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.egg,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.gear,
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPinkColor,
        unselectedItemColor: kBlackColor,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
