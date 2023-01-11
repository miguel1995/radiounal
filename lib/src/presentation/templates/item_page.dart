import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_episodio_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_emision_bloc.dart';
import 'package:radiounal/src/business_logic/firebase/firebaseLogic.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:platform_device_id/platform_device_id.dart';

class ItemPage extends StatefulWidget {
  final String title;
  final String message;
  final int uid; //Indica el id del episodio de podcast o emisora de radio
  final String from; //Indica la página desde lacual fue llamada (home, detail)

  const ItemPage(
      {Key? key, required this.title, required this.message, required this.uid, required this.from})
      : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late String title;
  late String message;
  late int uid;
  late String from;

  final blocRadioEmision = RadioEmisionBloc();
  final blocPodcastEpisodio = PodcastEpisodioBloc();
  late dynamic element = null;

  late TargetPlatform? platform;
  late String _localPath;
  late bool _permissionReady;

  String? _deviceId;
  bool _isFavorito = false;
  late FirebaseLogic firebaseLogic;

  @override
  void initState() {
    super.initState();

    initPlatformState();

    firebaseLogic = FirebaseLogic();

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';

    title = widget.title;
    message = widget.message;
    uid = widget.uid;
    from = widget.from;

    if (message == "RADIO") {
      blocRadioEmision.fetchEmision(uid);
      blocRadioEmision.subject.stream.listen((event) {
        setState(() {
          element = event[0];
        });
      });
    } else if (message == "PODCAST") {
      blocPodcastEpisodio.fetchEpisodio(uid);
      blocPodcastEpisodio.subject.stream.listen((event) {
        setState(() {
          element = event[0];
        });
      });
    }

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBarRadio(),
      body: Center(
        child: Column(children: [
          drawContentDescription(element),
          drawContentBtns(element)
        ]),
      ),
      //bottomNavigationBar: BottomNavigationBarRadio(),
    );
  }

  @override
  void dispose() {
    blocPodcastEpisodio.dispose();
    blocRadioEmision.dispose();
    super.dispose();
  }

  Widget drawContentDescription(dynamic element) {
    var w = MediaQuery
        .of(context)
        .size
        .width;
    final DateTime now = (element != null)
        ? DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(element.date)
        : DateTime.now();
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(now);

    return Column(children: [
      Container(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          InkWell(
              onTap: () {

                if(_isFavorito == true){
                  firebaseLogic.eliminarFavorite(uid, _deviceId).then((value) => {
                    setState((){
                      _isFavorito = false;
                    })
                  });
                }else{
                  firebaseLogic.agregarFavorito(uid, message, (message == "RADIO") ? "EMISION" : "EPISODIO", _deviceId).then(
                          (value) => {
                        if(value == true){
                          //print('DocumentSnapshot added with ID: ${doc.id}');
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Agregado a mis favoritos"))
                          ),
                          setState((){
                            _isFavorito = true;
                          })
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Se ha presentado un problema, intentelo más tarde"))
                          )
                        }
                      });
                }

              },
              child: Container(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child:  (_isFavorito==true)?Icon(Icons.favorite,
                      color: Theme.of(context).primaryColor
                  ):Icon(Icons.favorite_border,
                      color: Theme.of(context).primaryColor
                  )

              )

          ),
          InkWell(
              onTap: () {
                //TODO: Comopartir url
                print("COMPARTIR URL");
                Share.share(element.url,
                    subject: "Radio UNAL - ${element.title}");
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: const Icon(Icons.share)))
        ]),
      ),
      Container(
          width: w * 0.40,
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
              imageUrl: (element != null) ? element.imagen : "",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Container(
                      height: w * 0.25,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      child: Image.asset("assets/images/logo.png")),
            ),
          )),
      Container(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(left: 20, top: 30),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .appBarTheme
                  .foregroundColor,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff121C4A).withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(5, 5), // changes position of shadow
                ),
              ],
            ),
            child: Text(
              (element != null) ? element.categoryTitle : "",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Text(
          (element != null) ? element.title : "",
          style: const TextStyle(
              color: Color(0xff121C4A),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 20),
        child: Text(
          formatted,
          style: const TextStyle(fontSize: 10, color: Color(0xff666666)),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        alignment: Alignment.centerLeft,
        child: Text(
          (message == "RADIO") ? "Radio" : "Podcast",
          style: TextStyle(
            fontSize: 15,
            color: Theme
                .of(context)
                .primaryColor,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Container(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          alignment: Alignment.centerLeft,
          child: RatingBar(
            initialRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 20.0,
            ratingWidget: RatingWidget(
              full: SvgPicture.asset('assets/icons/star.svg'),
              half: SvgPicture.asset('assets/icons/star.svg'),
              empty: SvgPicture.asset('assets/icons/star_border.svg'),
            ),
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            onRatingUpdate: (rating) {
              //TODO: Este valor se debe enviar al servicio de Estadisticas
              print(rating);
            },
          ))
    ]);
  }

  Widget drawContentBtns(dynamic element) {
    var w = MediaQuery
        .of(context)
        .size
        .width;

    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: InkWell(
              onTap: () {
                //TODO: Reproducir audio
                print(element.audio);
              },
              child: Container(
                  width: w * 0.35,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(radius: 1, colors: [
                      Colors.white54.withOpacity(0.3),
                      const Color(0xff121C4A),
                    ]),
                    borderRadius: BorderRadius.circular(5),
                    color: Theme
                        .of(context)
                        .primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff121C4A).withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        "Reproducir",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      )
                    ],
                  )))),
      Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      downloadFile(element.audio, "audio", "mp3");
                    },
                    child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(radius: 1, colors: [
                            Colors.white54.withOpacity(0.3),
                            const Color(0xffFCDC4D)
                          ]),
                          borderRadius: BorderRadius.circular(5),
                          color: Theme
                              .of(context)
                              .appBarTheme
                              .foregroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff121C4A).withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.download,
                          size: 40,
                        )))),

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
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(radius: 1, colors: [
                            Colors.white54.withOpacity(0.3),
                            Color((message == "PODCAST")
                                ? 0xffFCDC4D
                                : 0x68FFFFFF)
                          ]),
                          borderRadius: BorderRadius.circular(5),
                          color: Theme
                              .of(context)
                              .appBarTheme
                              .foregroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff121C4A).withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.wifi,
                          size: 40,
                        )))),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: InkWell(
                    onTap: () {
                      if (message == "PODCAST") {
                        downloadFile(element.pdf, "transcripcion", "pdf");
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(radius: 1, colors: [
                            Colors.white54.withOpacity(0.3),
                            Color((message == "PODCAST")
                                ? 0xffFCDC4D
                                : 0x68FFFFFF)

                          ]),
                          borderRadius: BorderRadius.circular(5),
                          color:
                          Theme
                              .of(context)
                              .appBarTheme
                              .foregroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff121C4A).withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.arrow_downward,
                              size: 40,
                            ),
                            Text(
                              "Transcripción",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            )
                          ],
                        )))),
          ],
        ),
      ),
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: InkWell(
              onTap: () {
                if (from == "HOME_PAGE") {
                  Navigator.popUntil(context, ModalRoute.withName("/"));
                  Navigator.pushNamed(context, "/detail",
                      arguments: ScreenArguments(
                          title,
                          message,
                          element.categoryUid
                      )
                  );
                } else if (from == "DETAIL_PAGE") {
                  Navigator.pop(context);
                }
              },
              child: Container(
                  width: w * 0.40,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(radius: 1, colors: [
                      Colors.white54.withOpacity(0.3),
                      const Color(0xff121C4A),
                    ]),
                    borderRadius: BorderRadius.circular(5),
                    color: Theme
                        .of(context)
                        .primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff121C4A).withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(
                        "Más episodios",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      )
                    ],
                  ))))
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
        await Dio()
            .download(urlFile, localPathName);
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
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
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
    print("deviceId->$_deviceId");

    firebaseLogic.validateFavorite(uid, _deviceId).then(
            (value) => {
          setState(()=>{
            _isFavorito = value
          })
        });

  }

}
