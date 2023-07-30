import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_episodios_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_seriesyepisodios_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_califica_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_programasyemisiones_bloc.dart';
import 'package:radiounal/src/business_logic/firebase/firebaseLogic.dart';
import 'package:radiounal/src/data/models/info_model.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/confirm_dialog.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../business_logic/bloc/radio_emisiones_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../business_logic/firebase/push_notifications.dart';
import '../partials/favorito_btn.dart';

Function? globalCallbackRedrawableListView;

class DetailPage extends StatefulWidget {
  final String title;
  final String message;
  final int uid; //Indica el id de la serie podcast o programa de radio
  final dynamic elementContent; // almacena un objeto SerieModel o ProgramaModel

  const DetailPage(
      {Key? key,
      required this.title,
      required this.message,
      required this.uid,
      this.elementContent})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

  Function? reloadlist;
class _DetailPageState extends State<DetailPage> {
  late String title;
  late String message;
  late int uid;
  late int page;
  late dynamic elementContent; // almacena un objeto SerieModel o ProgramaModel
  bool isLoading = false;
List elementList=[];

  final blocRadioEmisiones = RadioEmisionesBloc();
  final blocPodcastEpisodios = PodcastEpisodiosBloc();
  final blocPodcastSeriesYEpisodios = PodcastSeriesYEpisodiosBloc();
  final blocRadioProgramasYEmisiones = RadioProgramasYEmisionesBloc();
  final blocRadioCalifica = RadioCalificaBloc();

  ScrollController _scrollController = ScrollController();
  ScrollController _scrollControllerSilver = ScrollController();

  var size = null;
  double paddingTop = 0;

  String? _deviceId;
  bool _isSeguido = false;
  int _currentScore = 0;
  late FirebaseLogic firebaseLogic;
  late PushNotification pushNotification;

  int totalPages = 0;
  List<Widget> cardList = [];
  late FavoritoBtn favoritoBtn;
  bool isListLoading = false;
 bool isDarkMode =false;

  @override
  initState() { var brightness = MediaQuery.of(context).platformBrightness;
  isDarkMode = brightness == Brightness.dark;
    super.initState();

    initPlatformState();

    pushNotification = PushNotification();
    firebaseLogic = FirebaseLogic();

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';
    title = widget.title;
    message = widget.message;
    uid = widget.uid;
    page = 1;
    elementContent = widget.elementContent;
    favoritoBtn = FavoritoBtn(uid: uid, message: message, isPrimaryColor: true);
/*
    print(title);
    print(message);
    print(uid);
    print(page);
    print(elementContent.toString());*/

    firebaseLogic.validateSeguido(uid, _deviceId).then((value) => {
          setState(() {
            _isSeguido = value;
          })
        });

    firebaseLogic
        .validateEstadistica(uid, _deviceId, message.toUpperCase(),
            (message == "RADIO") ? "PROGRAMA" : "SERIE")
        .then((value) => {
              if (value != null && value != "" && value != null)
                {
                  setState(() {
                    _currentScore = value;
                  })
                }
            });

    print(">>> SI te estoy siguiendo: ${_isSeguido}");

    if (message == "RADIO") {
      blocRadioEmisiones.fetchEmisiones(uid, page);
    } else if (message == "PODCAST") {
      blocPodcastEpisodios.fetchEpisodios(uid, page);
    }

    //elementContent llega en Null desde la vista de home-Masescuchachos y home-destacados
    if (elementContent == null) {
      if (message == "RADIO") {
        blocRadioProgramasYEmisiones.fetchProgramsaYEmisiones([uid], []);
        blocRadioProgramasYEmisiones.subject.stream.listen((event) {
          if (event["programas"] != null) {
            if (event["programas"].length > 0) {
              print(event["programas"][0]);
              setState(() {
                elementContent = event["programas"][0];
              });
            }
          }
        });
      } else if (message == "PODCAST") {
        blocPodcastSeriesYEpisodios.fetchSeriesYEpisodios([uid], []);
        blocPodcastSeriesYEpisodios.subject.stream.listen((event) {
          if (event["series"] != null) {
            if (event["series"].length > 0) {
              setState(() {
                elementContent = event["series"][0];
              });
            }
          }
        });
      }
    }

    _scrollControllerSilver.addListener(() {
      //   print(">> SILVER");
      //   print(_scrollControllerSilver.position.maxScrollExtent);
      //   print(_scrollControllerSilver.offset);

      if (_scrollControllerSilver.position.maxScrollExtent ==
          _scrollControllerSilver.offset) {
        if (page < totalPages) {
          page++;
          print("listener -> page: $page");
          setState(() {
            isLoading = true;
            //reloadlist!=null?reloadlist!():{};
          });
          Future.delayed(Duration(milliseconds: 10000), () {
            setState(() {
              globalCallbackRedrawableListView!();
              isLoading = false;
            });
          });
          if (message == "RADIO") {
            print("fetch emisiones");
            blocRadioEmisiones.fetchEmisiones(uid, page);
          } else {
            print("fetch episodios");
            blocPodcastEpisodios.fetchEpisodios(uid, page);
          }
        }
      }
    });
    // _scrollController.addListener(() {
    //   print(">> listener");
    //   print(_scrollController.position.maxScrollExtent);
    //   print(_scrollController.offset);

    //   if (_scrollController.position.maxScrollExtent ==
    //       _scrollController.offset) {
    //     print('bottom limit reached');
    //     if (page < totalPages) {
    //       page++;
    //       print('page: $page');
    //       setState(() {
    //         isLoading = true;
    //       });
    //       Future.delayed(Duration(milliseconds: 5000), () {
    //         setState(() {
    //           isLoading = false;
    //         });
    //       });
    //       if (message == "RADIO") {
    //         blocRadioEmisiones.fetchEmisiones(uid, page);
    //       } else {
    //         blocPodcastEpisodios.fetchEpisodios(uid, page);
    //       }
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    paddingTop = size.width * 0.30;

    SliverAppBar sliverAppBar = SliverAppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Container(),
        ],
        backgroundColor: Colors.transparent,
        expandedHeight: 450,
        flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.all(0.0),
            collapseMode: CollapseMode.pin,
            background: drawContentDescription(
                elementContent,
                MediaQuery.of(context).size.width,
                uid!,
                _deviceId!=null?_deviceId:"",
                message!,
                _isSeguido!,
                pushNotification!,
                firebaseLogic!,
                favoritoBtn!)));

    _sliverList(AsyncSnapshot<Map<String, dynamic>> snapshot) {
      SliverList sliverList = SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Column(
              children: [
                drawContentList(snapshot),
              ],
            );
          },
          childCount: 1,
        ),
      );
      return sliverList;
    }

    return Scaffold(
        //extendBodyBehindAppBar: true,
        endDrawer: const Menu(),
        appBar: AppBarRadio(enableBack: true),
        body: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fondo_blanco_amarillo.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: StreamBuilder(
                stream: (message == "RADIO")
                    ? blocRadioEmisiones.subject.stream
                    : blocPodcastEpisodios.subject.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  Widget child;

                  if (snapshot.hasData) {
                    child = CustomScrollView(
                      controller: _scrollControllerSilver,
                      slivers: <Widget>[sliverAppBar, _sliverList(snapshot)],
                    );
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
                })));
  }

  @override
  void dispose() {
    blocPodcastEpisodios.dispose();
    blocRadioEmisiones.dispose();
    _scrollController.dispose();
    _scrollControllerSilver.dispose();
    super.dispose();
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

  Widget drawContentList(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    InfoModel infoModel;
    infoModel = snapshot.data!["info"];
    totalPages = infoModel.pages;

    return Container(
        //color: Colors.green,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
            //color: Colors.cyan,
            //height: MediaQuery.of(context).size.height * 0.1,
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "${infoModel.count} resultados",
              style: const TextStyle(
                color: Color(0xff121C4A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                decorationColor: Color(0xFFFCDC4D),
              ),
            ),
          ),
          /*Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Página ${page} de ${infoModel.pages}",
                    style: const TextStyle(
                      color: Color(0xff121C4A),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      decorationColor: Color(0xFFFCDC4D),
                    ),
                  ),
                ),*/
          //Container(
          // height: isLoading
          //    ? MediaQuery.of(context).size.height * 0.8
          //     : MediaQuery.of(context).size.height,
          // child:
          buildList(snapshot)
          // )
          ,
          if (isLoading)
            Container(
              //color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.1,
              child: const Center(
                  child: SpinKitFadingCircle(
                color: Color(0xffb6b3c5),
                size: 50.0,
              )),
            )
        ]));
  }

  Widget buildList(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    return (AsyncSnapshot<Map<String, dynamic>> snapshot) {
      var list = snapshot.data!["result"];
    list?.forEach((element) => {
          if (!elementList.contains(element))
            {cardList.add(buildCard(element)), elementList.add(element)}
        });
      return RedrawableListView(
          scrollController: _scrollController, cardList: cardList);
    }(snapshot);
  }

  Widget buildCard(element) {
    var w = MediaQuery.of(context).size.width;

    final DateTime now =
        DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(element.date);
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(now);

    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/item",
              arguments: ScreenArguments(title, message, element.uid,
                  from: "DETAIL_PAGE"));
        },
        child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      fit: BoxFit.cover,
                      imageUrl: element.imagen,
                      placeholder: (context, url) => const Center(
                          child: SpinKitFadingCircle(
                        color: Color(0xffb6b3c5),
                        size: 50.0,
                      )),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/default.png"),
                    ),
                  )),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        element.title,
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
                        "$formatted ${(element != null && element.duration != null && element.duration != '') ? formatDurationString(element.duration) : ''}",
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xff666666)),
                      ),
                    )
                  ]))
            ])));
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
    print("deviceId->$_deviceId");
  }

  String formatDurationString(String duration) {
    String formatted = "";
    if (duration != null || duration != "") {
      if (duration.substring(0, 2) == "00") {
        formatted = "| " + duration.substring(3);
      } else {
        formatted = "| " + duration;
      }
    }

    return formatted;
  }

  Widget drawContentDescription(
      dynamic element,
      var w,
      int uid,
      var _deviceId,
      String message,
      bool _isSeguido,
      PushNotification pushNotification,
      FirebaseLogic firebaseLogic,
      FavoritoBtn favoritoBtn) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(children: [
          Container(
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              favoritoBtn,
              InkWell(
                  onTap: () {
                    Share.share("Escucha Radio UNAL -  ${element.url}",
                        subject: "Radio UNAL - ${element.title}");
                  },
                  child: Container(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: SvgPicture.asset(
                          'assets/icons/icono_compartir_redes.svg')))
            ]),
          ),
          Container(
              width: w * 0.40,
              height: w * 0.40,
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
                  fit: BoxFit.cover,
                  imageUrl: element.imagen,
                  placeholder: (context, url) => const Center(
                      child: SpinKitFadingCircle(
                    color: Color(0xffb6b3c5),
                    size: 50.0,
                  )),
                  errorWidget: (context, url, error) => Container(
                      width: w * 0.40,
                      child: Image.asset("assets/images/default.png")),
                ),
              )),
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              element.title,
              style: TextStyle(
                shadows: [
                  Shadow(
                      color: Theme.of(context).primaryColor,
                      offset: const Offset(0, -5))
                ],
                color: Colors.transparent,
                decorationThickness: 2,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decorationColor: Color(0xFFFCDC4D),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              element.description,
              maxLines: 4,
              style: const TextStyle(color: Color(0xff121C4A), fontSize: 12),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              (message == "RADIO") ? "Radio" : "Podcast",
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              alignment: Alignment.centerLeft,
              child: RatingBar(
                initialRating: _currentScore.toDouble(),
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20.0,
                ratingWidget: RatingWidget(
                  full: SvgPicture.asset(
                      'assets/icons/icono_estrellita_completa.svg'),
                  half: SvgPicture.asset(
                      'assets/icons/icono_estrellita_completa.svg'),
                  empty: SvgPicture.asset(
                      'assets/icons/icono_estrellita_borde.svg'),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                onRatingUpdate: (rating) {
                  print(rating);
                  DateTime today = DateTime.now();
                  String dateStr = "${today.day}-${today.month}-${today.year}";
                  //Agrega Estadistica a Backend Typo3
                  blocRadioCalifica.addEstadistica(
                      element.uid,
                      element.title,
                      message.toUpperCase(),
                      (message == "RADIO") ? "PROGRAMA" : "SERIE",
                      rating.toInt(),
                      dateStr);
                  //Agrega Estadistica a firebase
                  firebaseLogic
                      .agregarEstadistica(
                          uid,
                          message,
                          (message == "RADIO") ? "PROGRAMA" : "SERIE",
                          _deviceId,
                          rating.toInt(),
                          today.microsecondsSinceEpoch)
                      .then((value) => {
                            if (value == true)
                              {print(">>> Estadistica agregada a firebase")}
                            else
                              {
                                print(
                                    ">>> No se puede  agregar la Estadistica a firebase")
                              }
                          });

                  showConfirmDialog(context, "STATISTIC");
                },
              )),
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: InkWell(
                  onTap: () {
                    if (_isSeguido == true) {
                      firebaseLogic
                          .eliminarSeguido(uid, _deviceId)
                          .then((value) => {
                                pushNotification.removeNotificationItem(
                                    "${message.toUpperCase()}-$uid"),
                                setState(() {
                                  _isSeguido = false;
                                })
                              });
                    } else {
                      firebaseLogic
                          .agregarSeguido(
                              uid,
                              message,
                              (message == "RADIO") ? "PROGRAMA" : "SERIE",
                              _deviceId)
                          .then((value) => {
                                if (value == true)
                                  {
                                    //print('DocumentSnapshot added with ID: ${doc.id}');
                                    pushNotification.addNotificationItem(
                                        "${message.toUpperCase()}-$uid"),
                                    showConfirmDialog(context, "FOLLOWED"),
                                    setState(() {
                                      _isSeguido = true;
                                    })
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Se ha presentado un problema, intentelo más tarde")))
                                  }
                              });
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).appBarTheme.foregroundColor,
                        gradient: const RadialGradient(
                            radius: 3,
                            colors: [Color(0xffFEE781), Color(0xffFFCC17)]),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff121C4A).withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        (_isSeguido) ? "Dejar de Seguir" : "Seguir",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )))),
        ]);
      },
    );
  }

  showConfirmDialog(BuildContext context, String strTipo) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 2), () {
            //Navigator.of(context).pop(true);
            Navigator.pop(context);
          });
          return ConfirmDialog(strTipo);
        });
  }
}

class RedrawableListView extends StatefulWidget {
  const RedrawableListView({
    super.key,
    required ScrollController scrollController,
    required this.cardList,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<Widget> cardList;

  @override
  State<RedrawableListView> createState() => _RedrawableListViewState();
}

class _RedrawableListViewState extends State<RedrawableListView> {
  callbackRedrawableListView() {
    setState(() {});
    widget._scrollController.jumpTo((widget._scrollController.offset - 100));
  }

  @override
  void initState() {
    // TODO: implement initState

    globalCallbackRedrawableListView = callbackRedrawableListView;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: widget._scrollController,
        children: widget.cardList);
  }
}
