import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refrij_app/screens/auth/login.dart';
import 'package:refrij_app/screens/auth/signup.dart';
import 'package:refrij_app/screens/auth/terms_and_conditions.dart';
import 'package:refrij_app/screens/ingredients.dart';
import 'package:refrij_app/screens/onboarding.dart';
import 'package:refrij_app/screens/recipe/generate_form.dart';
import 'package:refrij_app/screens/refrigerator_detail.dart';
import 'package:refrij_app/screens/settings/forgot_password.dart';
import 'package:refrij_app/screens/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/notif_service.dart';
import 'screens/home.dart';
import 'screens/refrigerators.dart';

int initScreen = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen") ?? 0;
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');

  runApp(const Refrij());
}

class Refrij extends StatelessWidget {
  const Refrij({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          initScreen == 0 || initScreen == null ? "/onboarding" : "/login",
      routes: {
        '/onboarding': (context) => const OnBoardingPageScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/terms_and_conditions': (context) =>
            const TermsAndConditionsSignUpPage(),
        '/home': (context) => const HomePageScreen(),
        '/refrigerators': (context) => const RefrigeratorScreen(),
        '/refrigeratorDetail': (context) => const RefrigeratorDetailScreen(),
        '/ingredients': (context) => const IngredientsScreen(),
        '/settings': (context) => const SettingsPageScreen(),
        '/forgot_password': (context) => const ForgotPasswordPageScreen(),
        '/generate_recipe_form': (context) => const GenerateRecipeFormPage(),
      },
      title: 'Refrij',
    );
  }
}
