import 'package:chip_list/chip_list.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:refrij_app/components/buttons/brown_button.dart';
import 'package:refrij_app/components/buttons/pink_button.dart';
import 'package:refrij_app/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class GenerateRecipeResultPage extends StatefulWidget {
  final List ingredients;

  const GenerateRecipeResultPage({Key? key, required this.ingredients})
      : super(key: key);

  @override
  State<GenerateRecipeResultPage> createState() =>
      _GenerateRecipeResultPageState();
}

class _GenerateRecipeResultPageState extends State<GenerateRecipeResultPage> {
  List recipes = [];
  List<String> _ingredients = [];

  String combineListToString(List<dynamic> list) {
    List<String> stringList =
        list.map((element) => element.toString()).toList();
    return stringList.join(', ');
  }

  void setResult() {
    setState(() {
      recipes = widget.ingredients;
      _ingredients =
          List<String>.from(widget.ingredients[0]["input_ingredients"]);
    });
  }

  @override
  void initState() {
    setResult();
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
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: PinkCircularButton(
            buttonText: 'BACK TO HOME',
            onButtonPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Your ingredients",
                      style: TextStyle(
                        fontFamily: 'Rubik Medium',
                        fontSize: 24.0,
                        color: kBlackColor,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ChipList(
                      supportsMultiSelect: true,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      listOfChipNames: _ingredients,
                      activeBgColorList: [Colors.white],
                      inactiveBgColorList: [Colors.white],
                      activeBorderColorList: [kBlackColor],
                      inactiveBorderColorList: [kBlackColor],
                      activeTextColorList: [kBlackColor],
                      inactiveTextColorList: [kBlackColor],
                      listOfChipIndicesCurrentlySeclected: [],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Recommended Recipes:",
                      style: TextStyle(
                        fontFamily: 'Rubik Medium',
                        fontSize: 24.0,
                        color: kBlackColor,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    for (var i in recipes)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 20.0),
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: kGreyColor,
                          border: Border.all(color: kBlackColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                i["title"].toString(),
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
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                i["courses"].toString() +
                                    " - " +
                                    i["cuisines"].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: const TextStyle(
                                  fontFamily: 'Rubik Regular',
                                  fontSize: 16.0,
                                  color: kBlackColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "Ingredients:",
                              style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontSize: 16.0,
                                color: kBlackColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            ExpandableText(
                              //combineListToString(i["ingredients"]).toString(),
                              i["ingredients"].toString(),
                              expandText: 'more',
                              collapseText: 'show less',
                              maxLines: 2,
                              linkColor: kPinkColor,
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            BrownCircularButton(
                              buttonText: "SEE HOW TO COOK",
                              onButtonPressed: () async {
                                Uri _url =
                                    Uri.parse(i["instructions"].toString());

                                if (!await launchUrl(_url)) {
                                  throw Exception('Could not launch $_url');
                                }
                              },
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
