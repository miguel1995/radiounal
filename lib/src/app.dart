
import 'package:flutter/material.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';
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
import 'package:radiounal/src/presentation/templates/item_page.dart';
import 'package:radiounal/src/presentation/templates/politics_page.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
     Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Radio UNAL',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/favourites': (context) => const FavouritesPage(),
        '/followed': (context) => const FollowedPage(),
        '/configurations': (context) => const ConfigurationsPage(),
        '/about': (context) => const AboutPage(),
        '/contacts': (context) => const ContactsPage(),
        '/politics': (context) => const PoliticsPage(),
        '/credits': (context) => const CreditsPage(),
        '/glossary': (context) => const GlossaryPage()
      },

      onGenerateRoute: (settings) {
        if (settings.name == "/content") {
          final args = settings.arguments as ScreenArguments;
          return MaterialPageRoute(
            builder: (context) {
              return ContentPage(
                title: args.title,
                message: args.message,
                page: args.number,
              );
            },
          );
        }
        else if (settings.name == "/detail") {
          final args = settings.arguments as ScreenArguments;
          return MaterialPageRoute(
            builder: (context) {
              return DetailPage(
                title: args.title,
                message: args.message,
                uid: args.number,
                elementContent: args.element,
              );
            },
          );
        }

        else if (settings.name == "/item") {
          final args = settings.arguments as ScreenArguments;
          return MaterialPageRoute(
            builder: (context) {
              return ItemPage(
                title: args.title,
                message: args.message,
                uid: args.number,
                from: args.from
              );
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
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





