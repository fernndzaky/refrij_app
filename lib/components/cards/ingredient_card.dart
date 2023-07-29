import 'package:flutter/material.dart';
import 'package:refrij_app/utilities/constants.dart';

class IngredientCard extends StatelessWidget {
  String ingredientName;
  int ingredientDuration;
  String ingredientID;
  void Function()? onTapFunction = () {};
  IngredientCard(
      {this.ingredientName = "",
      this.ingredientDuration = 0,
      required this.ingredientID,
      this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Container(
        width: 110.0,
        padding:
            EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: kGreyColor,
          border: Border.all(color: kBlackColor),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Text(
                textAlign: TextAlign.center,
                ingredientName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: const TextStyle(
                  fontFamily: 'Rubik Medium',
                  fontSize: 18.0,
                  color: kBlackColor,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Expires in ',
              style: TextStyle(
                fontFamily: 'Rubik Regular',
                fontSize: 14.0,
                color: kBlackColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5.0,
            ),
            ingredientDuration == 0
                ? Text(
                    'Today',
                    style: TextStyle(
                      fontFamily: 'Rubik Medium',
                      fontSize: 14.0,
                      color: kBlackColor,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    '$ingredientDuration day(s)',
                    style: TextStyle(
                      fontFamily: 'Rubik Medium',
                      fontSize: 14.0,
                      color: kBlackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }
}
