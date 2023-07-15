import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  String? _deviceId;
  late FirebaseLogic firebaseLogic;

  final blocRadio = RadioProgramasYEmisionesBloc();
  final blocPodcast = PodcastSeriesYEpisodiosBloc();

  List<int> listSeriesIds = [];
  List<int> listEpisodiosIds = [];
  List<int> listProgramasIds = [];
  List<int> listEmisionesIds = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    firebaseLogic = FirebaseLogic();

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

    firebaseLogic.findFavoriteByUserUid(_deviceId).then((value) => {
          //Filtra los IDs de los programas
          listProgramasIds = value
              .where((e) => e["tipo"] == "PROGRAMA")
              .map((e) => int.parse(e["uid"].toString()))
              .toList(),

          //Filtra los IDs de las Emisiones
          listEmisionesIds = value
              .where((e) => e["tipo"] == "EMISION")
              .map((e) => int.parse(e["uid"].toString()))
              .toList(),

          blocRadio.fetchProgramsaYEmisiones(
              listProgramasIds, listEmisionesIds),

          //Filtra los IDs de las Series
          listSeriesIds = value
              .where((e) => e["tipo"] == "SERIE")
              .map((e) => int.parse(e["uid"].toString()))
              .toList(),

          //Filtra los IDs de los Episodios
          listEpisodiosIds = value
              .where((e) => e["tipo"] == "EPISODIO")
              .map((e) => int.parse(e["uid"].toString()))
              .toList(),
          blocPodcast.fetchSeriesYEpisodios(listSeriesIds, listEpisodiosIds)
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
    List<Widget> cardList = [];

    listRadio?["programas"]
        .forEach((element) => cardList.add(buildCard(element, "Radio")));

    listRadio?["emisiones"]
        .forEach((element) => cardList.add(buildCard(element, "Radio")));

    listPodcast?["series"]
        .forEach((element) => cardList.add(buildCard(element, "Podcast")));

    listPodcast?["episodios"]
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
        "Su listado de contenidos favoritos está vacío.",
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

    //TODO: agregar la duracion del Audio
    String formatted = "";
    if (element is EpisodioModel || element is EmisionModel) {
      final DateTime now =
          DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(element.date);
      final DateFormat formatter = DateFormat('dd MMMM yyyy');
      formatted = formatter.format(now);
    }

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
                          color: const Color(0xff121C4A).withOpacity(0.3),
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
                            child: Image.asset("assets/images/logo.png")),
                      ),
                    )),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (element is EpisodioModel || element is EmisionModel)
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin: const EdgeInsets.only(left: 20, bottom: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.foregroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff121C4A).withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(
                                5, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(
                        element.categoryTitle,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Container(
                    width: w * 0.55,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      element.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      site,
                      style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).primaryColor,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      "$formatted ${(element != null && (element is EmisionModel || element is EpisodioModel) && element.duration != null) ? formatDurationString(element.duration) : ''}",
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xff666666)),
                    ),
                  ),
                ])
              ])),
          Expanded(
            child: InkWell(
                onTap: () {
                  _showMyDialog(element, site);
                },
                child: Container(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: Icon(Icons.favorite,
                        color: Theme.of(context).primaryColor))),
          )
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
                Text('¿Desea remover su favorito?',
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
                    .eliminarFavorite(element.uid, _deviceId)
                    .then((value) => {
                          //actualiza el listado
                          initPlatformState()

                          //TODO: eliminar el elemento de la lista, en lugar de recargar todo el listo
                          //TODO: AGRAGAR UN LOADING
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
