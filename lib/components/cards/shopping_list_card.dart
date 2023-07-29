import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refrij_app/utilities/constants.dart';

import '../../screens/bottom_sheets/shopping_item_detail.dart';

class ShoppingListCard extends StatefulWidget {
  String name;
  String qty;
  int itemID;
  final bool isChecked;
  Function(bool?)? onCheckBoxTapped;
  final Function(bool?)? toggleCheckBoxState;
  Function(BuildContext)? onDelete;

  ShoppingListCard(
      {this.name = "",
      this.qty = "",
      this.isChecked = false,
      this.toggleCheckBoxState,
      required this.itemID,
      required this.onDelete,
      required this.onCheckBoxTapped});
  @override
  State<ShoppingListCard> createState() => _ShoppingListCardState();
}

class _ShoppingListCardState extends State<ShoppingListCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      height: 80.0,
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: kPinkColor),
      ),
      child: Center(
        child: Slidable(
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                // An action can be bigger than the others.
                flex: 1,
                onPressed: widget.onDelete,
                foregroundColor: kPinkColor,
                icon: FontAwesomeIcons.trash,
              ),
            ],
          ),
          child: ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child:
                          ShoppingItemDetailBS(param: widget.itemID.toString()),
                    ),
                  ),
                  isScrollControlled: true,
                );
              },
              contentPadding: EdgeInsets.all(0.0),
              title: Text(
                widget.name,
                style: TextStyle(
                  fontFamily: 'Rubik Medium',
                  fontSize: 18.0,
                  color: kBlackColor,
                ),
              ),
              subtitle: Text(
                'Quantity: ' + widget.qty,
                style: TextStyle(
                  fontFamily: 'Rubik Regular',
                  fontSize: 14.0,
                  color: kBlackColor,
                ),
              ),
              trailing: Checkbox(
                activeColor: kBrownColor,
                value: widget.isChecked,
                onChanged: widget.onCheckBoxTapped,
              )),
        ),
      ),
    );
  }
}
