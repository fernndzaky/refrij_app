import 'package:chip_list/chip_list.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refrij_app/components/buttons/pink_button.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

import '../../controllers/authController.dart';
import '../../controllers/ingredientController.dart';
import 'generate_result.dart';

class GenerateRecipeFormPage extends StatefulWidget {
  const GenerateRecipeFormPage({Key? key}) : super(key: key);

  @override
  State<GenerateRecipeFormPage> createState() => _GenerateRecipeFormPageState();
}

class _GenerateRecipeFormPageState extends State<GenerateRecipeFormPage> {
  IngredientController ingredientController = IngredientController();
  bool _isLoading = false;
  List<String> ingredients = [];
  List<dynamic> _ingredients = [];
  List<int> selectedIngredients = [0];
  String course = "Anything";
  String cuisine = "Anything";

  int calculateDayDifference(String given_date) {
    DateTime now = DateTime.now();
    DateTime givenDate = DateTime.parse(given_date);

    int differenceInDays = givenDate.difference(now).inDays + 1;

    return differenceInDays;
  }

  List<String> extractIngredientNames(List<Map<String, dynamic>> data) {
    List<String> ingredientNames = [];

    for (var item in data) {
      if (item.containsKey('IngredientName')) {
        String ingredientName = item['IngredientName'].toString().toLowerCase();
        ingredientNames.add(ingredientName);
      }
    }

    return ingredientNames;
  }

  void getIngredients() async {
    setState(() {
      _isLoading = true;
    });
    final user_id = await AuthController.getUserID();

    var result = await ingredientController.getAllIngredients(user_id);

    if (result["success"] == true) {
      List<String> ingredientNames = await extractIngredientNames(
          result["content"].cast<Map<String, dynamic>>());
      setState(() {
        ingredients = ingredientNames;
        _ingredients = result["content"];
        _isLoading = false;
      });
      print(ingredients);
    } else {
      if (result["errorMessage"] == "No records found") {
        setState(() {
          ingredients = [];
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  List<String> getSelectedIngredients(List<int> selectedIndices) {
    return selectedIndices.map((index) => ingredients[index]).toList();
  }

  void getRecommendation(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    List<String> selectedList = getSelectedIngredients(selectedIngredients);
    print('getting recommendation..');
    var result = await ingredientController.getRecommendation(
        selectedList, course, cuisine);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => GenerateRecipeResultPage(ingredients: result),
        ),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    getIngredients();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.angleLeft,
              color: kBrownColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: PinkCircularButton(
            buttonText: _isLoading == false ? 'GENERATE RECIPE' : 'LOADING..',
            onButtonPressed: () {
              getRecommendation(context);
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Generate Recipe",
                    style: TextStyle(
                      fontFamily: 'Rubik Medium',
                      fontSize: 24.0,
                      color: kBlackColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  //TOP SECTION
                  SizedBox(
                    height: 30.0,
                  ),

                  Text(
                    "Discover delicious recipes tailored to your available ingredients, powered by the magic of machine learning. Choose your preferences and ingredients and click the Button below to unlock a world of culinary possibilities!",
                    style: TextStyle(
                      fontFamily: 'Rubik Regular',
                      fontSize: 16.0,
                      color: kLightGreyColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  SizedBox(
                    height: 30.0,
                  ),

                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                    ),
                    items: [
                      "Anything",
                      "Main Dishes",
                      "Desserts",
                      "Salads",
                      "Side Dishes",
                      "Soups",
                      "Appetizers",
                      "Condiments and Sauces",
                      "Lunch and Snacks",
                      "Breakfast and Brunch",
                      "Breads",
                      "Beverages",
                      "Cocktails",
                      "Afternoon Tea",
                    ],
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Course",
                        hintText: "Food Course",
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
                      setState(() {
                        course = value!;
                      });
                    },
                    selectedItem: "Anything",
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                    ),
                    items: [
                      "Anything",
                      "American",
                      "Italian",
                      "Mexican",
                      "Asian",
                      "French",
                      "Indian",
                      "Kid-Friendly",
                      "Southwestern",
                      "Thai",
                      "Barbecue",
                      "Chinese",
                      "Southern & Soul Food",
                      "Greek",
                      "Mediterranean",
                      "Spanish",
                      "Cuban",
                      "Cajun & Creole",
                      "Moroccan",
                      "Japanese",
                      "Irish",
                      "English",
                      "Hawaiian",
                      "German",
                      "Hungarian",
                      "Portuguese",
                      "Vietnamese"
                    ],
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Cuisine",
                        hintText: "Food Cuisine",
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
                      setState(() {
                        cuisine = value!;
                      });
                    },
                    selectedItem: "Anything",
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    "Select Your Ingredients",
                    style: TextStyle(
                      fontFamily: 'Rubik Medium',
                      fontSize: 18.0,
                      color: kBlackColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  if (_isLoading == true)
                    Container(
                        width: double.infinity,
                        child: SkeletonText(height: 50)),
                  if (_isLoading == false)
                    ChipList(
                      supportsMultiSelect: true,
                      shouldWrap: true,
                      runSpacing: 5,
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      listOfChipNames: ingredients,
                      activeBgColorList: [kBrownColor],
                      inactiveBgColorList: [Colors.white],
                      activeBorderColorList: [kBrownColor],
                      inactiveBorderColorList: [kBrownColor],
                      activeTextColorList: [Colors.white],
                      inactiveTextColorList: [kBlackColor],
                      listOfChipIndicesCurrentlySeclected: selectedIngredients,
                      extraOnToggle: (val) {
                        setState(() {
                          selectedIngredients = selectedIngredients;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
