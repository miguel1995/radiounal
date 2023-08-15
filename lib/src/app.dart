import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';
import 'package:radiounal/src/presentation/home.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/templates/about_page.dart';
import 'package:radiounal/src/presentation/templates/browser_page.dart';
import 'package:radiounal/src/presentation/templates/browser_result_page.dart';
import 'package:radiounal/src/presentation/templates/configurations_page.dart';
import 'package:radiounal/src/presentation/templates/contacts_page.dart';
import 'package:radiounal/src/presentation/templates/content_page.dart';
import 'package:radiounal/src/presentation/templates/credits_page.dart';
import 'package:radiounal/src/presentation/templates/detail_page.dart';
import 'package:radiounal/src/presentation/templates/favourites_page.dart';
import 'package:radiounal/src/presentation/templates/followed_page.dart';
import 'package:radiounal/src/presentation/templates/item_page.dart';
import 'package:radiounal/src/presentation/templates/politics_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:radiounal/src/presentation/splash.dart';
import 'package:radiounal/src/presentation/templates/tab_menu.dart';
import '../firebase_options.dart';
import 'business_logic/firebase/push_notifications.dart';
import 'package:adaptive_theme/adaptive_theme.dart';


Function? resetH;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<BottomNavigationBarRadioState> keyPlayer = GlobalKey();
 bool isDarkMode =false;
  @override
  void initState() { var brightness = SchedulerBinding.instance.window.platformBrightness;
  isDarkMode = brightness == Brightness.dark;
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => {initPushNotifications()});

  }



  void initPushNotifications() {
    final pushNotification = new PushNotification();
    pushNotification.initNotifications();

    //Cuando el usuario presiona la push Notification se llema este bloque de código
    // Llega el Uid de la serie o programa enviado desde el backend de radio y podcast
    pushNotification.mensajes.listen((uid) {

      print(uid);


/*
      if (eventUid != null) {
        blocDetail.getEventById(int.parse(eventUid));

        bool firstTime = true;

        blocDetail.circularEventSubject.stream.listen((event) {
          if (event != null) {
            if (firstTime) {
              firstTime = false;

              navigatorKey.currentState.push(MaterialPageRoute(
                  builder: (context) => EventDetailPage(circularEvent: event)));
            }
          }
        });
      }*/
    });
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.red,
          primaryColor: Color(0xFFFCDC4D),
          primaryColorDark: isDarkMode?Color(0xff121C4A):Color(0xFFFCDC4D),
            fontFamily: 'AncizarSans',
          textTheme: const TextTheme(
              // bodyText2: TextStyle(
              //     // fontSize: 14.0,
              //       fontWeight: FontWeight.bold,
              //     color: Colors.white),
              headline1: TextStyle(
                  // fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  color: Colors.white),
                  ),
            appBarTheme:  AppBarTheme(
                color: Color(0xFFFCDC4D), foregroundColor: Color(0xff121C4A)
                //color: Color(isDarkMode?0xff121C4A:0xFFFCDC4D), 
                // backgroundColor: Color(isDarkMode?:0xFFFCDC4D:0xff121C4A),
                // foregroundColor:Color(isDarkMode?0xff121C4A:0xFFFCDC4D)
                ), 
                 drawerTheme:
                 DrawerThemeData(backgroundColor: isDarkMode?Color(0xFFFCDC4D):Color(0xff121C4A))),
        
        light: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor:  Color(0xff121C4A),

            // Define the default font family.
            fontFamily: 'AncizarSans',
            textTheme:  TextTheme(
                headline1: TextStyle(
                    // fontSize: 72.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
                headline2: TextStyle(color: Colors.red),
                headline3: TextStyle(color: Colors.red),
                headline4: TextStyle(color: Colors.red),
                headline5: TextStyle(color: Colors.red),
                headline6: TextStyle(
                    // fontSize: 36.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.red),
                bodyText1: TextStyle(color: Colors.red),
                bodyText2: TextStyle(
                    // fontSize: 14.0,
                    color: Color(isDarkMode?0xFFFCDC4D:0xff121C4A))),
            appBarTheme:  AppBarTheme(
                color: isDarkMode?Color(0xFFFCDC4D):Color(0xff121C4A), foregroundColor: isDarkMode?Color(0xff121C4A):Color(0xFFFCDC4D)),
            drawerTheme:
                 DrawerThemeData(backgroundColor: isDarkMode?Color(0xFFFCDC4D):Color(0xff121C4A))),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) {
          return


            MaterialApp(
            theme: theme,
            //Tema Oscuro, se usa cuando se activa el modo oscuro
            darkTheme: darkTheme,
            title: 'Radio UNAL',
            debugShowCheckedModeBanner: false,
            builder: (context, Widget? childElement) {
              return Scaffold(
                  body: Stack(children: [
                if (childElement != null)
                  Container(
                      padding: const EdgeInsets.only(bottom: 96),
                      child: childElement),
                Positioned(
                    bottom: 0, child: BottomNavigationBarRadio(key: keyPlayer)),
                    Splash()
              ]));
            },
            initialRoute: "/",
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(builder: (context) {
                  return
                    WillPopScope(
                        onWillPop: () async {
                          // Devuelve un valor "false" para deshabilitar el botón de retroceso
                          return Future.value(false);
                        },
                    child:
                  Home(keyPlayer.currentState?.playMusic));
                });
              } else if (settings.name == '/browser') {
                return MaterialPageRoute(builder: (context) {
                  return BrowserPage();
                });
              } else if (settings.name == '/configurations') {
                return MaterialPageRoute(builder: (context) {
                  return ConfigurationsPage();
                });
              } else if (settings.name == '/about') {
                return MaterialPageRoute(builder: (context) {
                  return AboutPage();
                });
              } else if (settings.name == '/contacts') {
                return MaterialPageRoute(builder: (context) {
                  return ContactsPage();
                });
              } else if (settings.name == '/politics') {
                return MaterialPageRoute(builder: (context) {
                  return PoliticsPage();
                });
              } else if (settings.name == '/credits') {
                return MaterialPageRoute(builder: (context) {
                  return CreditsPage();
                });
              } else if (settings.name == "/content") {
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
              } else if (settings.name == "/detail") {
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
              } else if (settings.name == "/item") {
                final args = settings.arguments as ScreenArguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return ItemPage(
                        title: args.title,
                        message: args.message,
                        uid: args.number,
                        from: args.from,
                        callBackPlayMusic: keyPlayer.currentState?.playMusic);
                  },
                );
              } else if (settings.name == "/browser-result") {
                final args = settings.arguments as ScreenArguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return BrowserResultPage(
                        title: args.title,
                        message: args.message,
                        page: args.number,
                        element: args.element);
                  },
                );
              } else if (settings.name == "/favourites") {
                final args = settings.arguments as ScreenArguments;

                return MaterialPageRoute(
                  builder: (context) {
                    return TabMenuPage(
                      tabIndex: args.number,
                    );
                  },
                );
              } else if (settings.name == "/followed") {
                final args = settings.arguments as ScreenArguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return TabMenuPage(
                      tabIndex: args.number,
                    );
                  },
                );
              }

              assert(false, 'Need to implement ${settings.name}');
              return null;
            },
          );
        });
  }


}
