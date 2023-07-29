import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refrij_app/components/appbars/pink_appbar.dart';
import 'package:refrij_app/components/bottom_navigation_bar.dart';
import 'package:refrij_app/components/cards/home_fridge_card.dart';
import 'package:refrij_app/components/cards/ingredient_card.dart';
import 'package:refrij_app/components/cards/shopping_list_card.dart';
import 'package:refrij_app/controllers/refrigeratorController.dart';
import 'package:refrij_app/controllers/shoppingController.dart';
import 'package:refrij_app/screens/bottom_sheets/add_new_shopping_item.dart';
import 'package:refrij_app/screens/refrigerator_detail.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

import '../components/buttons/pink_button.dart';
import '../controllers/authController.dart';
import '../controllers/ingredientController.dart';
import '../controllers/notif_service.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  RefrigeratorController refrigeratorController = RefrigeratorController();
  IngredientController ingredientController = IngredientController();
  ShoppingController shoppingController = ShoppingController();
  final cron = Cron();
  AuthController authController = AuthController();

  void scheduleNotificationPush() {
    print('scheduled');
    cron.schedule(Schedule.parse('58 11 * * *'), pushNotif);
    cron.schedule(Schedule.parse('00 08 * * *'), pushNotif);
  }

  void pushNotif() {
    // Call your notification function here
    NotificationService().showNotification(
      title: 'Ingredients expiring soon!',
      body: 'Please check your available ingredients.',
    );
  }

  List<dynamic> refrigerators = [];
  bool _isLoading = false;
  bool _isIngredientLoading = false;
  bool _isShoppingLoading = false;
  List<dynamic> _ingredients = [];
  List<dynamic> _shoppingItems = [];

  void getShoppingItems() async {
    setState(() {
      _isShoppingLoading = true;
    });
    final user_id = await AuthController.getUserID();
    var result = await shoppingController.getShoppingItems(user_id);

    if (result["success"] == true) {
      setState(() {
        _shoppingItems = result["content"];
      });
    } else {
      setState(() {
        _shoppingItems = [];
      });
    }

    setState(() {
      _isShoppingLoading = false;
    });
  }

  Future<void> _pullRefresh() async {
    getRefrigerators();
    getIngredients();
    getShoppingItems();
  }

  void deleteShoppingItem(int itemID) async {
    setState(() {
      _shoppingItems.removeWhere((item) => item["ID"] == itemID);
    });
    await shoppingController.deleteShoppingItem(itemID.toString());
  }

  int calculateDayDifference(String given_date) {
    DateTime now = DateTime.now();
    DateTime givenDate = DateTime.parse(given_date);

    int differenceInDays = givenDate.difference(now).inDays + 1;

    return differenceInDays;
  }

  void getRefrigerators() async {
    setState(() {
      _isLoading = true;
    });
    final user_id = await AuthController.getUserID();
    var result = await refrigeratorController.getRefrigerators(user_id);
    if (result["success"] == true) {
      setState(() {
        refrigerators = result["content"];
      });
    } else {
      if (result["errorMessage"] == "No refrigerator found") {
        setState(() {
          refrigerators = [];
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void updateIsBought(int itemIdToUpdate, bool newIsBoughtValue) {
    setState(() {
      for (int i = 0; i < _shoppingItems.length; i++) {
        if (_shoppingItems[i]["ID"] == itemIdToUpdate) {
          _shoppingItems[i]["IsBought"] = newIsBoughtValue;
          break;
        }
      }
    });
  }

  void getIngredients() async {
    setState(() {
      _isIngredientLoading = true;
    });
    final user_id = await AuthController.getUserID();

    var result =
        await ingredientController.getUserIngredients(user_id.toString());

    if (result["success"] == true) {
      setState(() {
        _ingredients = result["content"];
        _isIngredientLoading = false;
      });
    } else {
      setState(() {
        _ingredients = [];
        _isIngredientLoading = false;
      });
    }
  }

  void sendNotif() async {
    final user_id = await AuthController.getUserID();

    if (await ingredientController.hasExpiringIngredientsTomorrow(user_id) ==
        true) {
      scheduleNotificationPush();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getRefrigerators();
    getIngredients();
    getShoppingItems();
    sendNotif();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PinkAppBar(),
      backgroundColor: kPinkColor,
      bottomNavigationBar: StickyBottomNavigationBar(),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
            child: SafeArea(
          child: Column(
            children: <Widget>[
              //Refrigerators Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 30.0,
                  left: 20.0,
                ),
                color: kPinkColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //Refrigerators Text
                    Text(
                      'Refrigerators',
                      style: TextStyle(
                        fontFamily: 'Rubik Medium',
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    //Fridges section

                    _isLoading == false
                        ? refrigerators?.isNotEmpty == true
                            ? Container(
                                height: 105.0,
                                color: kPinkColor,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: refrigerators == null
                                        ? 0
                                        : refrigerators?.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return RefrigeratorCard(
                                        refrigeratorName: refrigerators[index]
                                            ["RefrigeratorName"],
                                        refrigeratorID: refrigerators[index]
                                            ['ID'],
                                      );
                                    }))
                            : Container(
                                width: MediaQuery.of(context).size.width,
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
                                margin: EdgeInsets.only(right: 15.0),
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
                                          'No refrigerators found 😢',
                                          style: TextStyle(
                                            fontFamily: 'Rubik Medium',
                                            fontSize: 18.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                        : Container(
                            padding: EdgeInsets.only(right: 20.0),
                            width: double.infinity,
                            child: SkeletonText(height: 105)),
                  ],
                ),
              ),
              //Recent Ingredients Section
              Container(
                width: double.infinity,
                color: Colors.white,
                padding:
                    const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Recent Ingredients',
                      style: TextStyle(
                        fontFamily: 'Rubik Medium',
                        fontSize: 24.0,
                        color: kBlackColor,
                      ),
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
                              ),
                          if (_ingredients.isEmpty == true &&
                              _isIngredientLoading == false)
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          if (_isIngredientLoading == true)
                            Container(
                                width: double.infinity,
                                child: SkeletonText(height: 105)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding:
                    const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                child: PinkCircularButton(
                  buttonText: 'GENERATE RECIPE',
                  onButtonPressed: () {
                    Navigator.pushNamed(context, '/generate_recipe_form');
                  },
                ),
              ),
              //Shopping List Section
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(
                    top: 40, bottom: 40, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shopping List',
                          style: TextStyle(
                            fontFamily: 'Rubik Medium',
                            fontSize: 24.0,
                            color: kBlackColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.plus,
                            color: kBlackColor,
                          ),
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: NewShoppingItemBS(),
                                ),
                              ),
                              isScrollControlled: true,
                            );
                            getShoppingItems();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Swipte left to delete an item from the list.',
                      style: TextStyle(
                        fontFamily: 'Rubik Regular',
                        fontSize: 16.0,
                        color: kLightGreyColor,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    //Shopping List Card Section
                    _isShoppingLoading == false
                        ? _shoppingItems?.isNotEmpty == true
                            ? ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: 500, minHeight: 150.0),
                                child: ListView.builder(
                                  itemCount: _shoppingItems == null
                                      ? 0
                                      : _shoppingItems?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ShoppingItemCard(
                                        itemName: _shoppingItems[index]
                                            ["ItemName"],
                                        itemQty: _shoppingItems[index]
                                            ['Quantity'],
                                        isChecked: _shoppingItems[index]
                                            ['IsBought'],
                                        itemID: _shoppingItems[index]['ID'],
                                        onDelete: (context) async {
                                          deleteShoppingItem(
                                              _shoppingItems[index]['ID']);
                                        },
                                        onCheckBoxTapped:
                                            (bool? checkBoxState) async {
                                          updateIsBought(
                                              _shoppingItems[index]['ID'],
                                              !_shoppingItems[index]
                                                  ['IsBought']);
                                          await shoppingController
                                              .updateCheckBoxState(
                                                  _shoppingItems[index]['ID']
                                                      .toString(),
                                                  _shoppingItems[index]
                                                      ['IsBought']);
                                        });
                                  },
                                ),
                              )
                            : Container(
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
                                margin:
                                    EdgeInsets.only(bottom: 25.0, top: 20.0),
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
                                          'No items found 😢',
                                          style: TextStyle(
                                            fontFamily: 'Rubik Medium',
                                            fontSize: 18.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                        : Container(
                            width: double.infinity,
                            child: SkeletonText(height: 105)),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class RefrigeratorCard extends StatelessWidget {
  final String refrigeratorName;
  final int refrigeratorID;

  RefrigeratorCard({this.refrigeratorName = "", this.refrigeratorID = 0});
  @override
  Widget build(BuildContext context) {
    return HomeFridgeCard(
      fridgeName: refrigeratorName,
      onCardTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RefrigeratorDetailScreen(param: refrigeratorID.toString())),
        );
      },
    );
  }
}

class ShoppingItemCard extends StatelessWidget {
  final String itemName;
  final String itemQty;
  final int itemID;
  final bool isChecked;

  dynamic Function()? onLongPress;
  Function(BuildContext)? onDelete;
  Function(bool?)? onCheckBoxTapped;

  ShoppingItemCard(
      {this.itemName = "",
      this.itemQty = "",
      this.isChecked = false,
      this.itemID = 0,
      this.onDelete,
      this.onCheckBoxTapped});
  @override
  Widget build(BuildContext context) {
    return ShoppingListCard(
        name: itemName,
        qty: itemQty,
        isChecked: isChecked,
        itemID: itemID,
        onDelete: onDelete,
        onCheckBoxTapped: onCheckBoxTapped);
  }
}
