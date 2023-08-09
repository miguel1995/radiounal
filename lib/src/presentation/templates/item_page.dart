import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_episodio_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_emision_bloc.dart';
import 'package:radiounal/src/data/models/emision_model.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/confirm_dialog.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../business_logic/bloc/radio_califica_bloc.dart';
import '../../business_logic/firebase/firebaseLogic.dart';
import '../partials/download_form_dialog.dart';
import '../partials/favorito_btn.dart';

class ItemPage extends StatefulWidget {
  final String title;
  final String message;
  final int uid; //Indica el id del episodio de podcast o emisora de radio
  final String from; //Indica la página desde la cual fue llamada (home, detail)
  late Function(
      dynamic uidParam,
      dynamic audioUrlParam,
      dynamic imagenUrlParam,
      dynamic textParentParam,
      dynamic titleParam,
      dynamic textContentParam,
      dynamic dateParam,
      dynamic durationParam,
      dynamic typeParam,
      dynamic typeUrl,
      bool isFrecuencia,
      FavoritoBtn? favoritoBtn)? callBackPlayMusic;

  ItemPage(
      {Key? key,
      required this.title,
      required this.message,
      required this.uid,
      required this.from,
      required this.callBackPlayMusic})
      : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late String title;
  late String message;
  late int uid;
  late String from;

  int _currentScore = 0;
  late FirebaseLogic firebaseLogic;

  final blocRadioEmision = RadioEmisionBloc();
  final blocRadioCalifica = RadioCalificaBloc();
  final blocPodcastEpisodio = PodcastEpisodioBloc();

  late dynamic element = null;

  late TargetPlatform? platform;
  late String _localPath;
  late bool _permissionReady;
  String? _deviceId;

  late FavoritoBtn favoritoBtn;
  bool isDarkMode = false;
  bool showReproducirBtn = false;



Future<AdaptiveThemeMode?> themeMethod() async {
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
return savedThemeMode;
}

  @override
  void initState() {
    
print('=====================item_page');
   
    super.initState();
    initPlatformState();

    firebaseLogic = FirebaseLogic();

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';

    title = widget.title;
    message = widget.message;
    uid = widget.uid;
    from = widget.from;

    print(title);
    print(message);
    print(uid);
    print(from);

    favoritoBtn = FavoritoBtn(uid: uid, message: message, isPrimaryColor: true);

    firebaseLogic
        .validateEstadistica(uid, _deviceId, message.toUpperCase(),
            (message == "RADIO") ? "EMISION" : "EPISODIO")
        .then((value) => {
              if (value != null && value != "" && value != null)
                {
                  setState(() {
                    _currentScore = value;
                  })
                }
            });

    if (message == "RADIO") {
      blocRadioEmision.fetchEmision(uid);
      blocRadioEmision.subject.stream.listen((event) {
        setState(() {
          element = event[0];
        });

        if(event[0] !=  null){
          if(event[0].audio !=  null) {
            if(event[0].audio !=  "") {
              setState(() {
                showReproducirBtn = true;
              });
            }
          }
        }
      });
    } else if (message == "PODCAST") {
      blocPodcastEpisodio.fetchEpisodio(uid);
      blocPodcastEpisodio.subject.stream.listen((event) {
        setState(() {
          element = event[0];
        });

        if(event[0] !=  null){
          if(event[0].audio !=  null) {
            if(event[0].audio !=  "") {
              setState(() {
                showReproducirBtn = true;
              });
            }
          }
        }

      });
    }



    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
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
  }

  @override
  Widget build(BuildContext context) {
        themeMethod().then((value) {
          setState(() {
            
     isDarkMode=value==AdaptiveThemeMode.dark;
          });
    });
    return Scaffold(extendBodyBehindAppBar: true,
        endDrawer: Menu(),
        appBar: AppBarRadio(enableBack: true),
        body: Container(padding: EdgeInsets.only(top: 120),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isDarkMode
                    ? "assets/images/FONDO_AZUL_REPRODUCTOR.png"
                    : "assets/images/fondo_blanco_amarillo.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(children: [
                drawContentDescription(element),
                drawContentBtns(element)
              ]),
            )));
  }

  @override
  void dispose() {
    blocPodcastEpisodio.dispose();
    blocRadioEmision.dispose();
    super.dispose();
  }

  Widget drawContentDescription(dynamic element) {
    var w = MediaQuery.of(context).size.width;
    final DateTime now = (element != null)
        ? DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(element.date)
        : DateTime.now();
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(now);

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
                      'assets/icons/icono_compartir_redes.svg',
                      color: isDarkMode?Color(0xFFfcdf4d):Color(0xFF121C4A),
                      )))
        ]),
      ),
      Container(
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: (element != null) ? element.imagen : "",
          imageBuilder: (context, imageProvider) => SizedBox(
              width: w * 0.4,
              height: w * 0.4,
              child: Container(
                //width: w * 0.40,
                //height: w * 0.40,
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
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          placeholder: (context, url) => const Center(
              child: SpinKitFadingCircle(
            color: Color(0xffb6b3c5),
            size: 50.0,
          )),
          errorWidget: (context, url, error) => Container(
              width: w * 0.40, child: Image.asset("assets/images/default.png")
          ),
        ),
      ),
      if (element != null &&
          element.categoryTitle != null &&
          element.categoryTitle != "")
        Container(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              margin: const EdgeInsets.only(left: 20, top: 30),
              decoration: BoxDecoration(
                color: Color(0xFFFCDC4D),
                boxShadow: [
                  BoxShadow(
                    color: Color( 0xff121C4A)
                        .withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(5, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Text(
                (element != null) ? element.categoryTitle : "",
                style:
                     TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
                    color:  Color(0xFF121C4A)
                    ),
              ),
            )),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
        child: Text(
          (element != null) ? element.title : "",
          style: TextStyle(
              color: Color(isDarkMode ? 0xFFFFFFFF : 0xff121C4A),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 20),
        child: Text(
          "$formatted ${(element != null && element.duration != null) ? formatDurationString(element.duration) : ''}",
          style:  TextStyle(fontSize: 11, color: isDarkMode? Color(0xFF989FBA) :Color(0xff666666)),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        alignment: Alignment.centerLeft,
        child: Text(
          (message == "RADIO") ? "Radio" : "Podcast",
          style: TextStyle(
            fontSize: 15,
            color: isDarkMode?Color(0xFFFFFFFF):Color(0xFF121C4A),
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
              empty:
                  SvgPicture.asset('assets/icons/icono_estrellita_borde.svg'),
            ),
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            onRatingUpdate: (rating) {
              DateTime today = DateTime.now();
              String dateStr = "${today.day}-${today.month}-${today.year}";
              blocRadioCalifica.addEstadistica(
                  element.uid,
                  element.title,
                  message.toUpperCase(),
                  (message == "RADIO") ? "EMISION" : "EPISODIO",
                  rating.toInt(),
                  dateStr);

              //Agrega Estadistica a firebase
              firebaseLogic
                  .agregarEstadistica(
                      uid,
                      message,
                      (message == "RADIO") ? "EMISION" : "EPISODIO",
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
          ))
    ]);
  }

  Widget drawContentBtns(dynamic element) {

    //print("element.audio ${element.audio}");

    return Column(children: [
      Row(children: [
    if (showReproducirBtn)
      Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: InkWell(
                onTap: () {

                  print(element.audio);

                  if (element != null) {
                    if (element.audio != null) {
                      widget.callBackPlayMusic!(
                        element.uid,
                        element.audio,
                        element.imagen,
                        element.categoryTitle,
                        element.title,
                        (message == "RADIO")
                            ? element.bodytext
                            : element.teaser,
                        element.date,
                        element.duration,
                        message,
                        element.url,
                        false,
                        favoritoBtn,
                      );
                    }
                  }
                },
                child: Container(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(radius: 2, colors: [
                       isDarkMode?Color(0xFFFCDC4D): Color(0xff216278),
                        isDarkMode ? Color(0xFFFCDC4D) : Color(0xff121C4A)
                      ]),
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Color( 0xff121C4A)
                              .withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children:  [
                        Icon(
                          Icons.play_arrow,
                          color: isDarkMode?Color(0xFF121C4A):Color(0xFFFFFFFF),
                          size: 30,
                        ),
                        Text(
                          "Reproducir",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode?Color(0xFF121C4A):Color(0xFFFFFFFF),
                              fontSize: 16),
                        )
                      ],
                    ))))
      ]),
      Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      showFormDialog(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          gradient: const RadialGradient(
                              radius: 0.8,
                              colors: [Color(0xffFEE781), Color(0xffFFCC17)]),
                          borderRadius: BorderRadius.circular(5),
                          color:Color(0xFF121C4A),
                          boxShadow: [
                            BoxShadow(
                              color: Color( 0xff121C4A)
                                  .withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                            'assets/icons/icono_flecha_descarga.svg',
                            width: 20)))),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      if (message == "PODCAST") {
                        downloadFile(element.rss, "rss", "txt");
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(radius: 0.8, colors: [
                            (message == "PODCAST")
                                ? Color( 0xFFFCDC4D)
                                : Colors.white54.withOpacity(0.3),
                            Color((message == "PODCAST")
                                ? 0xffFFCC17
                                :  0x68FFFFFF)
                          ]),
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFF121C4A),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff121C4A)
                                  .withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset("assets/icons/icono_rss.svg",
                            width: 20)))),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      if (message == "PODCAST") {
                        downloadFile(element.pdf, "transcripcion", "pdf");
                      }
                    },
                    child:

                    Container(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(radius: 1.5, colors: [
                            (message == "PODCAST")
                                ? Color( 0xFFFCDC4D)
                                : Colors.white54.withOpacity(0.3),
                            (message == "PODCAST")
                                ?Color( 0xffFFCC17)
                                : Color( 0x68FFFFFF)
                          ]),
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).appBarTheme.foregroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff121C4A)
                                  .withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                'assets/icons/icono_flechita_transcripcion.svg',
                                width: 17),
                            const Text(
                              "  Transcripción",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17,
                                  color: Color(0xFF121C4A)
                                  ),
                            )
                          ],
                        )))),
          ],
        ),
      ),
      if (element != null &&
          element.categoryTitle != null &&
          element.categoryTitle != "")
        Row(children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: InkWell(
                  onTap: () {
                    if (from == "HOME_PAGE" ||
                        from == "FAVOURITES_PAGE" ||
                        from == "BROWSER_RESULT_PAGE") {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/detail",
                          arguments: ScreenArguments(
                              title, message, element.categoryUid));
                    } else if (from == "DETAIL_PAGE") {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(radius: 2, colors: [
                         isDarkMode ? Color(0xFFFCDC4D) : Color(0xff216278),
                          isDarkMode ? Color(0xFFFCDC4D) :Color( 0xff121C4A)
                        ]),
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Color( 0xff121C4A)
                                .withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                           Icon(
                            Icons.arrow_back_ios_new,
                            color: isDarkMode?Color(0xFF121C4A):Color(0xFFFFFFFF),
                            size: 20,
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child:  Text(
                                "Más episodios",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode?Color(0xFF121C4A):Color(0xFFFFFFFF),
                                    fontSize: 16),
                              ))
                        ],
                      ))))
        ])
    ]);
  }

  downloadFile(String urlFile, String media, String extension) async {
    String localPathName = "";

    _permissionReady = await _checkPermission();
    if (_permissionReady) {
      await _prepareSaveDir();

      final snackBar = SnackBar(
        content: Text("Descargando .${extension.toString()} ..."),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Algo de código para ¡deshacer el cambio!
          },
        ),
      );

      // Encuentra el Scaffold en el árbol de widgets y ¡úsalo para mostrar un SnackBar!
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      try {
        localPathName = "$_localPath/radiounal_$media${element.uid}.$extension";
        print(urlFile);
        await Dio().download(urlFile, localPathName);
        final snackBar = SnackBar(
          content: Text('Archivo ${extension.toString()} descargado'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              // Algo de código para ¡deshacer el cambio!
            },
          ),
        );

        // Encuentra el Scaffold en el árbol de widgets y ¡úsalo para mostrar un SnackBar!
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        print("Download Failed.\n\n" + e.toString());
      }
    }
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      if (await Permission.storage.request().isGranted) {
        // Los permisos ya están otorgados, continúa con la descarga o creación de archivos.
        print(
            '>>>>>>>Los permisos ya están otorgados, continúa con la descarga o creación de archivos.>>>>>>');
        return true;
      } else {
        // Los permisos no están otorgados, muestra una solicitud de permisos al usuario.
        print(
            '>>>>>>>>>>>>>>>>Los permisos no están otorgados, muestra una solicitud de permisos al usuario.>>>>>>>>>>>>>>>');

        if (await Permission.storage.shouldShowRequestRationale) {
          // El usuario ha rechazado los permisos anteriormente, muestra una explicación adicional si es necesario.
          print(
              '>>>>>>>>>>El usuario ha rechazado los permisos anteriormente, muestra una explicación adicional si es necesario.>>>>>>>>>>>>');
          return false;
        }
        // Solicita los permisos.
        print('>>>>>>>>>>>Solicita los permisos.>>>>>>>>>>>>');
        PermissionStatus status = await Permission.storage.request();
        if (status.isGranted) {
          // Los permisos han sido otorgados, continúa con la descarga o creación de archivos.
          return true;
          print(
              '>>>>>>>>>>>Los permisos han sido otorgados, continúa con la descarga o creación de archivos.>>>>>>>>>>>>>');
        } else {
          // Los permisos fueron denegados, maneja esta situación según tus necesidades.
          print(
              '>>>>>>>>>>>>Los permisos fueron denegados, maneja esta situación según tus necesidades.>>>>>>>>>>>');
          return false;
        }
      }
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    await savedDir.create(recursive: true);

    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else if (platform == TargetPlatform.iOS) {
      final appSupportDirectory = await getApplicationDocumentsDirectory();

      return appSupportDirectory!.path;
    } else {
      throw UnsupportedError("Plataforma no compatible");
    }
  }

  showFormDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DownloadFormDialog(callBackFormDialog);
        });
  }

  callBackFormDialog(bool status) {
    if (status == true) {
      downloadFile(element.audio, "audio", "mp3");
    }
  }

  String formatDurationString(String duration) {
    String formatted = "";
    if (duration != null && duration != "") {
      if (duration.substring(0, 2) == "00") {
        formatted = "| " + duration.substring(3);
      } else {
        formatted = "| " + duration;
      }
    }

    return formatted;
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
