import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../business_logic/firebase/push_notifications.dart';
import 'package:radiounal/src/business_logic/firebase/firebaseLogic.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {

  String? _deviceId;
  late FirebaseLogic firebaseLogic;
  late PushNotification pushNotification;

  List<int> listSeriesIds = [];
  List<int> listProgramasIds = [];


  bool light0 = true;

  late SharedPreferences prefs;
 bool isDarkMode =false;

  @override
  void initState() { var brightness = SchedulerBinding.instance.window.platformBrightness;
 isDarkMode = brightness == Brightness.dark;


    initializePreference();


    firebaseLogic = FirebaseLogic();
    pushNotification = PushNotification();
    initPlatformState();
  }

  Future<void> initPlatformState() async {

    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
    print("deviceId->$_deviceId");

    firebaseLogic.findSeguidosByUserUid(_deviceId).then((value) => {
      //Filtra los IDs de los programas
      listProgramasIds = value
          .where((e) => e["tipo"] == "PROGRAMA")
          .map((e) => int.parse(e["uid"].toString()))
          .toList(),

      //Filtra los IDs de las Series
      listSeriesIds = value
          .where((e) => e["tipo"] == "SERIE")
          .map((e) => int.parse(e["uid"].toString()))
          .toList(),

    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Switch(
          activeColor: Theme.of(context).appBarTheme.foregroundColor,
          inactiveThumbColor: Colors.black,
          value: light0,
          onChanged: (bool value) {
            setState(() {
              light0 = value;
              if(value){
                subscribeAllTopics();
              }else{
                unSubscribeAllTopics();
              }
            });
          },
        )
      ],
    );
  }

  unSubscribeAllTopics(){
    for (var uid in listSeriesIds) {
      pushNotification.removeNotificationItem("PODCAST-$uid");
    }

    for (var uid in listProgramasIds) {
      pushNotification.removeNotificationItem("RADIO-$uid");
    }

    prefs.setBool('hasNotifications', false);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Ya no recibirás más notificaciones"),
    ));
  }

  subscribeAllTopics(){
    print(listSeriesIds);
    print(listProgramasIds);

    for (var uid in listSeriesIds) {
      pushNotification.addNotificationItem("PODCAST-$uid");
    }

    for (var uid in listProgramasIds) {
      pushNotification.addNotificationItem("RADIO-$uid");
    }

    prefs.setBool('hasNotifications', true);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Ricibirás notificaciones"),
    ));


  }

  initializePreference() async{
    // obtain shared preferences
    prefs = await SharedPreferences.getInstance();
    setState(() {
      /**Actualiza variables de estado*/
      light0 = prefs.getBool('hasNotifications') ?? true;
    }
    );

  }

}
