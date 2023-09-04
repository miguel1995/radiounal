import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class PushNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // ignore: close_sinks
  final _mensajesStreamController = StreamController<dynamic>.broadcast();
  Stream<dynamic> get mensajes => _mensajesStreamController.stream;

  initNotifications() {
    print(">>> voy a pedir el token!!!");

    //Pedimos permisos a firebase para usar push_notifications
    _firebaseMessaging.requestPermission();
    //Solicitamos un token. Es unico para cada dispositivo
    _firebaseMessaging.getToken().then((token) {
      print("====  FCM TOKEN =====");
      //Nota: con este token se puede enviar notificaciones de pruebe desde firebase console
      // o desde el backend en el archivo unal_news/Clasess/Hooks/DataHandler.php
      print(token);
    });

    FirebaseMessaging.onMessage.listen((event) {
      print(">>>  onMessage");
      print(event);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print(">>>  Oprimir Push: ");
      print(message.data['uid']);
      print(message.data['site']);


      /*
       title: args.title,
                        message: args.message,
                        uid: args.number,
                        from: args.from,
      *
      * */

      if (Platform.isAndroid) {
        if (message != null) {
          if (message.data != null) {
            if (message.data['uid'] != null) {
              var uid = message.data['uid'];
              var site = message.data['site'];

              _mensajesStreamController.sink.add(
                  {
                  'uid':uid,
                    'site':site
                  });
            }
          }
        }
      }

      if (Platform.isIOS) {}
    });
  }

  //subcribe al servicio de pushNotifications
  //value: RADIO-{uidpPrograma}, PODCAST-{uidSerie}
  // ex: RADIO-5, PODCAST-10
  addNotificationItem(String value){
    _firebaseMessaging.subscribeToTopic(value);
  }

  //value: RADIO-{uidpPrograma}, PODCAST-{uidSerie}
  removeNotificationItem(String value){
    _firebaseMessaging.unsubscribeFromTopic(value);
  }

}
