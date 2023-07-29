import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:refrij_app/components/bottom_navigation_bar.dart';
import 'package:refrij_app/components/cards/ingredient_card.dart';
import 'package:refrij_app/controllers/ingredientController.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

import '../components/buttons/pink_button.dart';
import '../controllers/authController.dart';
import 'bottom_sheets/ingredient_detail.dart';

class IngredientsScreen extends StatefulWidget {
  final String param;

  const IngredientsScreen({
    Key? key,
    this.param = "",
  }) : super(key: key);

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  IngredientController ingredientController = IngredientController();
  AuthController authController = AuthController();

  bool showSpinner = false;
  List<dynamic> _ingredients = [];
  bool _isLoading = true;

  int calculateDayDifference(String given_date) {
    DateTime now = DateTime.now();
    DateTime givenDate = DateTime.parse(given_date);

    int differenceInDays = givenDate.difference(now).inDays + 1;

    return differenceInDays;
  }

  void getIngredients() async {
    setState(() {
      _isLoading = true;
    });
    final user_id = await AuthController.getUserID();

    var result = await ingredientController.getAllIngredients(user_id);

    if (result["success"] == true) {
      setState(() {
        _ingredients = result["content"];
        _isLoading = false;
      });
    } else {
      if (result["errorMessage"] == "No records found") {
        setState(() {
          _ingredients = [];
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void getIngredientsByFilter(String value) async {
    setState(() {
      _isLoading = true;
    });
    final user_id = await AuthController.getUserID();

    var result =
        await ingredientController.getAllIngredientsByFilter(user_id, value);

    if (result["success"] == true) {
      setState(() {
        _ingredients = result["content"];
        _isLoading = false;
      });
    } else {
      if (result["errorMessage"] == "No records found") {
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
    getIngredients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPinkColor,
        elevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PinkCircularButton(
          buttonText: 'GENERATE RECIPE',
          onButtonPressed: () {
            Navigator.pushNamed(context, '/generate_recipe_form');
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: StickyBottomNavigationBar(),
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
                          'Ingredients',
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
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          showSelectedItems: true,
                        ),
                        items: [
                          "All",
                          "Vegetables",
                          "Proteins",
                          "Grains and Cereals",
                          'Fruits',
                          'Herbs and Spices',
                          'Beverages',
                          'Others'
                        ],
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Category",
                            hintText: "Ingredient's Category",
                            labelStyle: TextStyle(
                              fontFamily: 'Rubik Regular',
                              fontSize: 18.0,
                              color: kBrownColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: kLightGreyColor), //<-- SEE
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: kLightGreyColor), //<-- SEE
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: kLightGreyColor), //<-- SEE
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value == "All") {
                            getIngredients();
                          } else {
                            getIngredientsByFilter(value!);
                          }
                        },
                        selectedItem: "All",
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
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
                                    getIngredients();
                                  },
                                ),
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
                            if (_isLoading == true)
                              Container(
                                  width: double.infinity,
                                  child: SkeletonText(height: 105)),
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
