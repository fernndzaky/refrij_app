import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

class OnBoardingPageScreen extends StatefulWidget {
  const OnBoardingPageScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingPageScreen> createState() => _OnBoardingPageScreenState();
}

class _OnBoardingPageScreenState extends State<OnBoardingPageScreen> {
  late int index;

  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image(
                  image: AssetImage('images/Donut_Icon.png'),
                  height: 300.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'WELCOME TO REFRIJ!',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Manage all of your groceries can never be easier with Refij!',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'With refrij, you can now monitor all items inside your refrigerator. You also can have multiple refrigetaros registered in Refrij.',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Swipe right to find out more!',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image(
                  image: AssetImage('images/Fridge.png'),
                  height: 300.0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'NEW WAY FOR GROCERY SHOPPING!',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Forget what groceries you should bur for today?',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'With refrij, you can now manage your own grocery shopping list, while checking what items available in your fridge!',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  static const width = 100.0;
  @override
  void initState() {
    super.initState();
    index = 0;
  }

  SizedBox _skipButton({void Function(int)? setIndex}) {
    return SizedBox(
      width: width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: defaultSkipButtonBorderRadius,
          color: defaultSkipButtonColor,
          child: InkWell(
            borderRadius: defaultSkipButtonBorderRadius,
            onTap: () {
              if (setIndex != null) {
                index = 1;
                setIndex(1);
              }
            },
            child: const Padding(
              padding: defaultSkipButtonPadding,
              child: Text(
                'Skip',
                style: defaultSkipButtonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox get _signupButton {
    return SizedBox(
      width: 200.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: defaultProceedButtonBorderRadius,
          color: defaultProceedButtonColor,
          child: InkWell(
            borderRadius: defaultProceedButtonBorderRadius,
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Padding(
              padding: defaultProceedButtonPadding,
              child: Text(
                'Get Started',
                style: defaultProceedButtonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Onboarding(
            pages: onboardingPagesList,
            onPageChange: (int pageIndex) {
              index = pageIndex;
            },
            footerBuilder: (context, dragDistance, pagesLength, setIndex) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: background,
                  border: Border.all(
                    width: 0.0,
                    color: background,
                  ),
                ),
                child: ColoredBox(
                  color: background,
                  child: Padding(
                    padding: const EdgeInsets.all(45.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        index != pagesLength - 1
                            ? _skipButton(setIndex: setIndex)
                            : _signupButton,
                        Padding(
                          padding: const EdgeInsets.only(right: 45.0),
                          child: CustomIndicator(
                            netDragPercent: dragDistance,
                            pagesLength: pagesLength,
                            indicator: Indicator(
                              indicatorDesign: IndicatorDesign.polygon(
                                polygonDesign: PolygonDesign(
                                  polygon: DesignType.polygon_circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
