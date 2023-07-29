import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:refrij_app/components/bottom_navigation_bar.dart';
import 'package:refrij_app/components/buttons/back_button.dart';
import 'package:refrij_app/components/buttons/brown_button.dart';
import 'package:refrij_app/components/buttons/small_delete_button.dart';
import 'package:refrij_app/components/buttons/white_button.dart';
import 'package:refrij_app/components/cards/ingredient_card.dart';
import 'package:refrij_app/controllers/ingredientController.dart';
import 'package:refrij_app/screens/bottom_sheets/add_new_ingredient.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

import '../controllers/refrigeratorController.dart';
import 'bottom_sheets/ingredient_detail.dart';

class RefrigeratorDetailScreen extends StatefulWidget {
  final String param;

  const RefrigeratorDetailScreen({
    Key? key,
    this.param = "",
  }) : super(key: key);

  @override
  State<RefrigeratorDetailScreen> createState() =>
      _RefrigeratorDetailScreenState();
}

class _RefrigeratorDetailScreenState extends State<RefrigeratorDetailScreen> {
  RefrigeratorController refrigeratorController = RefrigeratorController();
  IngredientController ingredientController = IngredientController();
  String _refrigeratorName = "Loading..";
  bool showSpinner = false;
  List<dynamic> _ingredients = [];
  bool _isLoading = true;

  void deleteRefrigerator() async {
    setState(() {
      showSpinner = true;
    });
    final refrigerator_id = widget.param;
    var result =
        await refrigeratorController.deleteRefigerator(refrigerator_id);

    if (result["success"] == true) {
      setState(() {
        showSpinner = false;
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/refrigerators', (Route<dynamic> route) => false);
    }
  }

  int calculateDayDifference(String given_date) {
    DateTime now = DateTime.now();
    DateTime givenDate = DateTime.parse(given_date);

    int differenceInDays = givenDate.difference(now).inDays + 1;

    return differenceInDays;
  }

  void getRefrigeratorDetail() async {
    setState(() {
      _isLoading = true;
    });
    final refrigerator_id = widget.param;
    var result =
        await refrigeratorController.getRefrigeratorDetail(refrigerator_id);
    if (result["success"] == true) {
      setState(() {
        _refrigeratorName = result["content"]["RefrigeratorName"];
      });
    }

    var result_ingredients =
        await ingredientController.getIngredients(int.parse(refrigerator_id));

    if (result_ingredients["success"] == true) {
      setState(() {
        _ingredients = result_ingredients["content"];
      });
    } else {
      if (result_ingredients["errorMessage"] == "No records found") {
        setState(() {
          _ingredients = [];
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getRefrigeratorDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPinkColor,
        elevation: 0,
        leading: WhiteBackButton(),
      ),
      bottomNavigationBar: StickyBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPinkColor,
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: NewIngredientBS(
                  param: int.parse(widget.param),
                ),
              ),
            ),
            isScrollControlled: true,
          );
          getRefrigeratorDetail();
        },
        child: Icon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  color: kPinkColor,
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 25.0, left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: Text(
                          _refrigeratorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                            fontFamily: 'Rubik Medium',
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SmallDeleteButton(
                        text: _isLoading == true ? 'LOADING..' : 'DELETE',
                        textColor: Colors.red,
                        onButtonPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => ModalProgressHUD(
                              opacity: 0.0,
                              color: kBrownColor,
                              inAsyncCall: showSpinner,
                              child: AlertDialog(
                                title: Text(
                                  'Are you sure want to delete',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Roboto Regular',
                                    fontSize: 18.0,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text(
                                      _refrigeratorName + '?',
                                      style: TextStyle(
                                        fontFamily: 'Rubik Medium',
                                        fontSize: 20.0,
                                        color: kBrownColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 40.0,
                                    ),
                                    WhiteCircularButton(
                                      buttonText: showSpinner == true
                                          ? 'Loading.. '
                                          : 'Yes, I am sure',
                                      onButtonPressed: () {
                                        deleteRefrigerator();
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    BrownCircularButton(
                                      buttonText: 'Cancel',
                                      onButtonPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 40.0,
                    horizontal: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Ingredients Section
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Wrap(
                          runSpacing: 25.0, // gap between lines
                          alignment: WrapAlignment.spaceBetween,
                          children: <Widget>[
                            if (_ingredients.isEmpty == false &&
                                _isLoading == false)
                              for (var i in _ingredients)
                                IngredientCard(
                                  ingredientName: i["IngredientName"],
                                  ingredientDuration:
                                      calculateDayDifference(i["ValidUntil"]),
                                  ingredientID: i["ID"].toString(),
                                  onTapFunction: () async {
                                    await showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: IngredientDetailBS(
                                              param: i["ID"].toString()),
                                        ),
                                      ),
                                      isScrollControlled: true,
                                    );
                                    getRefrigeratorDetail();
                                  },
                                ),
                            if (_isLoading == true)
                              Container(
                                  width: double.infinity,
                                  child: SkeletonText(height: 105)),
                            if (_ingredients.isEmpty == true &&
                                _isLoading == false)
                              Container(
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
                                      offset: Offset(
                                          1, 0), // changes position of shadow
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'No ingredients found 😢',
                                          style: TextStyle(
                                            fontFamily: 'Rubik Medium',
                                            fontSize: 18.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          '(I suggest you buy groceries)',
                                          style: TextStyle(
                                            fontFamily: 'Rubik Regular',
                                            fontSize: 12.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
