import 'package:flutter/material.dart';
import 'package:refrij_app/utilities/constants.dart';

class NormalFridgeCard extends StatelessWidget {
  String fridgeName;
  Function()? onCardTap;

  NormalFridgeCard({this.fridgeName = "New Fridge", this.onCardTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: double.infinity,
        height: 105.0,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: kBrownColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(1, 0), // changes position of shadow
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 25.0),
        child: Row(
          children: <Widget>[
            Image(
              image: AssetImage('images/Fridge.png'),
            ),
            SizedBox(
              width: 25.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: Text(
                    fridgeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      fontFamily: 'Rubik Medium',
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
