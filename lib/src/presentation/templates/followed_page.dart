import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_seriesyepisodios_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_programasyemisiones_bloc.dart';
import 'package:radiounal/src/business_logic/firebase/firebaseLogic.dart';
import 'package:radiounal/src/data/models/emision_model.dart';
import 'package:radiounal/src/data/models/episodio_model.dart';
import 'package:radiounal/src/data/models/programa_model.dart';
import 'package:radiounal/src/data/models/serie_model.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:rxdart/rxdart.dart';

import '../../business_logic/ScreenArguments.dart';
import '../../business_logic/firebase/push_notifications.dart';

class FollowedPage extends StatefulWidget {
  const FollowedPage({Key? key}) : super(key: key);

  @override
  State<FollowedPage> createState() => _FollowedPageState();
}

class _FollowedPageState extends State<FollowedPage> {
  String? _deviceId;
  late FirebaseLogic firebaseLogic;
  late PushNotification pushNotification;

  final blocRadio = RadioProgramasYEmisionesBloc();
  final blocPodcast = PodcastSeriesYEpisodiosBloc();

  List<int> listSeriesIds = [];
  List<int> listProgramasIds = [];
 bool isDarkMode =false;

  @override
  void initState() { 
    print('=====================followed_page');
    var brightness = SchedulerBinding.instance.window.platformBrightness;
  isDarkMode = brightness == Brightness.dark;
    super.initState();
    initPlatformState();
    firebaseLogic = FirebaseLogic();
    pushNotification = PushNotification();

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: CombineLatestStream.list([
          blocRadio.subject.stream,
          blocPodcast.subject.stream,
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          Widget child;

          if (snapshot.hasData) {
            child = drawContentList(snapshot);
          } else if (snapshot.hasError) {
            child = drawError(snapshot.error);
          } else {
            child = const Center(
                child: SpinKitFadingCircle(
              color: Color(0xffb6b3c5),
              size: 50.0,
            ));
          }
          return child;
        });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
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

    firebaseLogic.findSeguidosByUserUid(_deviceId).then((value) => {
          //Filtra los IDs de los programas
          listProgramasIds = value
              .where((e) => e["tipo"] == "PROGRAMA")
              .map((e) => int.parse(e["uid"].toString()))
              .toList(),

          blocRadio.fetchProgramsaYEmisiones(listProgramasIds, []),

          //Filtra los IDs de las Series
          listSeriesIds = value
              .where((e) => e["tipo"] == "SERIE")
              .map((e) => int.parse(e["uid"].toString()))
              .toList(),

          blocPodcast.fetchSeriesYEpisodios(listSeriesIds, [])
        });
  }

  @override
  void dispose() {
    blocPodcast.dispose();
    blocRadio.dispose();
    super.dispose();
  }

  Widget drawContentList(AsyncSnapshot<List<dynamic>> snapshot) {
    Map<String, dynamic> listRadio = snapshot.data![0];
    Map<String, dynamic> listPodcast = snapshot.data![1];
    int count = 0;
    List<Widget> cardList = [];

    listRadio?["programas"]
        .forEach((element) => cardList.add(buildCard(element, "Radio")));

    listPodcast?["series"]
        .forEach((element) => cardList.add(buildCard(element, "Podcast")));

    Widget widgetResult;

    if (cardList.length > 0) {
      widgetResult = Container(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: cardList,
            ),
          )));
    } else {
      widgetResult = Center(
          child: Text(
        "Su listado de contenidos está vacío.",
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
      ));
    }

    return widgetResult;
  }

  Widget drawError(error) {
    return Container(
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: ${error}'),
          )
        ],
      ),
    );
  }

  Widget buildCard(element, String site) {
    var w = MediaQuery.of(context).size.width;

    return Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(children: [
          InkWell(
              onTap: () {
                if (element is SerieModel || element is ProgramaModel) {
                  Navigator.pushNamed(context, "/detail",
                      arguments: ScreenArguments(
                          "SITE", site.toUpperCase(), element.uid,
                          element: element));
                }

                if (element is EpisodioModel || element is EmisionModel) {
                  Navigator.pushNamed(context, "/item",
                      arguments: ScreenArguments(
                          "SITE", site.toUpperCase(), element.uid,
                          from: "FAVOURITES_PAGE"));
                }
              },
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    width: w * 0.25,
                    height: w * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:  Color(isDarkMode?0xFFFCDC4D:0xff121C4A).withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: element.imagen,
                        placeholder: (context, url) => const Center(
                            child: SpinKitFadingCircle(
                          color: Color(0xffb6b3c5),
                          size: 50.0,
                        )),
                        errorWidget: (context, url, error) => Container(
                            height: w * 0.25,
                            color: Theme.of(context).primaryColor,
                            child: Image.asset(isDarkMode?'assets/images/logo_dark.png':"assets/images/logo.png",
              color: Color(isDarkMode?0xff121C4A:0xFFFCDC4D))),
                      ),
                    )),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    margin: const EdgeInsets.only(left: 20, bottom: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      boxShadow: [
                        BoxShadow(
                          color:  Color(isDarkMode?0xFFFCDC4D:0xff121C4A).withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset:
                              const Offset(5, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text(
                      element.title,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: w * 0.55,
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      site,
                      style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).primaryColor,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                ])
              ])),
          Expanded(
              child: Checkbox(
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: true,
                  onChanged: (bool? value) {
                    _showMyDialog(element, site);
                  }))
        ]));
  }

  Future<void> _showMyDialog(element, String site) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    '¿Desea dejar de seguir su contenido de $site: ${element.title} ?',
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).appBarTheme.foregroundColor))
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Si',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).appBarTheme.foregroundColor)),
              onPressed: () {
                //Navigator.of(context).pop();
                Navigator.pop(context);

                firebaseLogic
                    .eliminarSeguido(element.uid, _deviceId)
                    .then((value) => {
                          pushNotification.removeNotificationItem(
                              "${site.toUpperCase()}-${element.uid}"),

                          //actualiza el listado
                          initPlatformState()

                          //TODO: eliminar el elemento de la lista, en lugar de recargar todo el listo
                          /*if(site.toUpperCase() == "RADIO"){

                      }else if(site.toUpperCase() == "PODCAST"){

                      }*/
                        });
              },
            ),
            TextButton(
              child: Text(
                'No',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).appBarTheme.foregroundColor),
              ),
              onPressed: () {
                //Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Color? getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Theme.of(context).appBarTheme.foregroundColor;
    }
    return Theme.of(context).primaryColor;
  }

  String formatDurationString(String duration) {
    String formatted = "";
    if (duration != null) {
      if (duration.substring(0, 2) == "00") {
        formatted = "| " + duration.substring(3);
      } else {
        formatted = "| " + duration;
      }
    }

    return formatted;
  }
}
