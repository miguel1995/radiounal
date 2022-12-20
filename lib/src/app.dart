
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/home.dart';
import 'package:radiounal/src/presentation/templates/about_page.dart';
import 'package:radiounal/src/presentation/templates/configurations_page.dart';
import 'package:radiounal/src/presentation/templates/contacts_page.dart';
import 'package:radiounal/src/presentation/templates/content_page.dart';
import 'package:radiounal/src/presentation/templates/credits_page.dart';
import 'package:radiounal/src/presentation/templates/detail_page.dart';
import 'package:radiounal/src/presentation/templates/favourites_page.dart';
import 'package:radiounal/src/presentation/templates/followed_page.dart';
import 'package:radiounal/src/presentation/templates/glossary_page.dart';
import 'package:radiounal/src/presentation/templates/politics_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Radio UNAL',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/content': (context) => const ContentPage(),
        '/detail': (context) => const DetailPage(),
        '/favourites': (context) => const FavouritesPage(),
        '/followed': (context) => const FollowedPage(),
        '/configurations': (context) => const ConfigurationsPage(),
        '/about': (context) => const AboutPage(),
        '/contacts': (context) => const ContactsPage(),
        '/politics': (context) => const PoliticsPage(),
        '/credits': (context) => const CreditsPage(),
        '/glossary': (context) => const GlossaryPage()
      },


      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: const Color(0xff121C4A),

        // Define the default font family.
          fontFamily: 'AncizarSans',

        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0,
              fontWeight: FontWeight.bold,
            color: Colors.red),
          headline2: TextStyle(color: Colors.red),
          headline3: TextStyle(color: Colors.red),
          headline4: TextStyle(color: Colors.red),
          headline5: TextStyle(color: Colors.red),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic,
              color: Colors.red),
          bodyText1: TextStyle(color: Colors.red),
          bodyText2: TextStyle(fontSize: 14.0,
              color: Color(0xff121C4A))
        ),
        appBarTheme: const AppBarTheme(
          color:  Color(0xff121C4A),
          foregroundColor: Color(0xffFCDC4D)
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xff121C4A)
        )
      ),
    );
  }
}





