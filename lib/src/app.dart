
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
        primarySwatch: Colors.blue,
      ));
  }
}





