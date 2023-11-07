import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radiounal/src/app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {

  FlutterError.onError = (FlutterErrorDetails details) {
    print("[OMD] Error: ${details.exception}");
    print("[OMD] Stack trace:\n${details.stack}");

     };

  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  // Asegura que los Widgets estén inicializados
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


// Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}
