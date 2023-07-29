import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refrij_app/components/appbars/white_appbar.dart';
import 'package:refrij_app/components/bottom_navigation_bar.dart';
import 'package:refrij_app/components/cards/normal_fridge_card.dart';
import 'package:refrij_app/screens/refrigerator_detail.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

import '../controllers/authController.dart';
import '../controllers/refrigeratorController.dart';
import 'bottom_sheets/refrigerator_list_bs.dart';

class RefrigeratorScreen extends StatefulWidget {
  const RefrigeratorScreen({Key? key}) : super(key: key);

  @override
  State<RefrigeratorScreen> createState() => _RefrigeratorScreenState();
}

class _RefrigeratorScreenState extends State<RefrigeratorScreen> {
  RefrigeratorController refrigeratorController = RefrigeratorController();
  AuthController authController = AuthController();
  List<dynamic> refrigerators = [];
  bool _isLoading = true;

  void getRefrigerators() async {
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

  Future<void> _pullRefresh() async {
    getRefrigerators();
  }

  @override
  void initState() {
    // TODO: implement initState
    getRefrigerators();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Scaffold(
        appBar: WhiteAppBar(
          appBarText: "Refrigerators",
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
                  child: RefrigeratorListBS(),
                ),
              ),
              isScrollControlled: true,
            );
            getRefrigerators();
          },
          child: Icon(
            FontAwesomeIcons.plus,
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                  top: 40.0, bottom: 40.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Refrigerator List',
                    style: TextStyle(
                      fontFamily: 'Rubik Medium',
                      fontSize: 24.0,
                      color: kBlackColor,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  _isLoading == false
                      ? refrigerators?.isNotEmpty == true
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              color: Colors.white,
                              child: ListView.builder(
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
                          width: double.infinity,
                          child: SkeletonText(height: 105)),
                ],
              ),
            ),
          ),
        ),
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
    return NormalFridgeCard(
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
