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
import 'package:radiounal/src/business_logic/bloc/radio_programasyemisiones_bloc.dart';
import 'package:radiounal/src/business_logic/firebase/firebaseLogic.dart';
import 'package:radiounal/src/data/models/info_model.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../business_logic/bloc/radio_emisiones_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../business_logic/firebase/push_notifications.dart';

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

class _DetailPageState extends State<DetailPage> {
  late String title;
  late String message;
  late int uid;
  late int page;
  late dynamic elementContent; // almacena un objeto SerieModel o ProgramaModel

  final blocRadioEmisiones = RadioEmisionesBloc();
  final blocPodcastEpisodios = PodcastEpisodiosBloc();
  final blocPodcastSeriesYEpisodios = PodcastSeriesYEpisodiosBloc();
  final blocRadioProgramasYEmisiones = RadioProgramasYEmisionesBloc();

  ScrollController _scrollController = ScrollController();

  var size = null;
  double paddingTop = 0;

  String? _deviceId;
  bool _isFavorito = false;
  bool _isSeguido = false;
  late FirebaseLogic firebaseLogic;
  late PushNotification pushNotification;

  int totalPages = 0;
  List<Widget> cardList = [];

  @override
   initState()  {
    super.initState();

    initPlatformState();

    firebaseLogic = FirebaseLogic();
    pushNotification = PushNotification();

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';

    title = widget.title;
    message = widget.message;
    uid = widget.uid;
    page = 1;
    elementContent = widget.elementContent;

    if (message == "RADIO") {
      blocRadioEmisiones.fetchEmisiones(uid, page);
    } else if (message == "PODCAST") {
      blocPodcastEpisodios.fetchEpisodios(uid, page);
    }

    //elementContent llega en Null desde la vista de home-Masescuchachos y home-destacados
    if(elementContent == null){

      if (message == "RADIO") {
        blocRadioProgramasYEmisiones.fetchProgramsaYEmisiones([uid], []);
        blocRadioProgramasYEmisiones.subject.stream.listen((event) {

          if(event["programas"]!=null){
                if(event["programas"].length > 0){
                  print(event["programas"][0]);
                  setState((){
                    elementContent = event["programas"][0];
                  });

                }
          }

        });
      } else if (message == "PODCAST") {
        blocPodcastSeriesYEpisodios.fetchSeriesYEpisodios([uid], []);
        blocPodcastSeriesYEpisodios.subject.stream.listen((event) {

          if(event["series"]!=null){
            if(event["series"].length > 0){
              setState((){
                elementContent = event["series"][0];
              });

            }
          }
        });
      }
    }

    _scrollController.addListener(() {
      if(_scrollController.position.maxScrollExtent == _scrollController.offset){

        if(page < totalPages){

            page++;


          if (message == "RADIO") {
            blocRadioEmisiones.fetchEmisiones(uid, page);
          } else {
            blocPodcastEpisodios.fetchEpisodios(uid, page);
          }
        }

      }

    });

  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    paddingTop = size.width * 0.30;

    return

      Scaffold(
          endDrawer: const Menu(),
          appBar:  AppBarRadio(enableBack:true),
        body:
        DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fondo_blanco_amarillo.png"),
                fit: BoxFit.cover,
              ),
            ),
            child:
        StreamBuilder(
            stream: (message == "RADIO")
                ? blocRadioEmisiones.subject.stream
                : blocPodcastEpisodios.subject.stream,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              Widget child;

              if (snapshot.hasData) {
                child = Column(
                  children: [
                    if(elementContent!=null)
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.53,
                        child: drawContentDescription(elementContent)),
                  drawContentList(snapshot)
                  ],
                );
              } else if (snapshot.hasError) {
                child = drawError(snapshot.error);
              } else {
                child = const Center(
                    child: SpinKitFadingCircle(
                      color: Color(0xffb6b3c5),
                      size: 50.0,
                    )
                );
              }
              return child;
            }))
        );
  }

  @override
  void dispose() {
    blocPodcastEpisodios.dispose();
    blocRadioEmisiones.dispose();
    _scrollController.dispose();
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

  Widget drawContentDescription(dynamic element) {
    var w = MediaQuery.of(context).size.width;

    return Column(children: [
      Container(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          InkWell(
              onTap: (){

                if(_isFavorito == true){
                  firebaseLogic.eliminarFavorite(uid, _deviceId).then((value) => {
                    setState((){
                      _isFavorito = false;
                    })
                  });
                }else{
                  firebaseLogic.agregarFavorito(uid, message, (message == "RADIO") ? "PROGRAMA" : "SERIE", _deviceId).then(
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
              child:   (_isFavorito==true)? SvgPicture.asset('assets/icons/icono_corazon_completo.svg') :
              SvgPicture.asset('assets/icons/icono_corazon_borde.svg')
              )
          ),
          InkWell(
              onTap: (){
                Share.share("Escucha Radio UNAL -  ${element.url}",
                    subject: "Radio UNAL - ${element.title}");
              },
              child: Container(
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: SvgPicture.asset('assets/icons/icono_compartir_redes.svg')
              ))
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
              imageUrl: element.imagen,
              placeholder: (context, url) => const Center(
                  child: SpinKitFadingCircle(
                    color: Color(0xffb6b3c5),
                    size: 50.0,
                  )
              ),
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
          style: const TextStyle(color: Color(0xff121C4A), fontSize: 12
          ),
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
            initialRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 20.0,
            ratingWidget: RatingWidget(
              full: SvgPicture.asset('assets/icons/icono_estrellita_completa.svg'),
              half: SvgPicture.asset('assets/icons/icono_estrellita_completa.svg'),
              empty: SvgPicture.asset('assets/icons/icono_estrellita_borde.svg'),
            ),
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            onRatingUpdate: (rating) {
              //TODO: Este valor se debe enviar al servicio de Estadisticas
              print(rating);
            },
          )),
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: InkWell(
              onTap: (){

                if(_isSeguido == true){
                  firebaseLogic.eliminarSeguido(uid, _deviceId).then((value) => {
                    pushNotification.removeNotificationItem("${message.toUpperCase()}-$uid"),
                    setState((){
                      _isSeguido = false;
                    })
                  });
                }else{
                  firebaseLogic.agregarSeguido(uid, message, (message == "RADIO") ? "PROGRAMA" : "SERIE", _deviceId).then(
                          (value) => {
                        if(value == true){
                          //print('DocumentSnapshot added with ID: ${doc.id}');
                          pushNotification.addNotificationItem("${message.toUpperCase()}-$uid"),

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Ahora está siguiendo este contenido"))
                          ),
                          setState((){
                            _isSeguido = true;
                          })
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Se ha presentado un problema, intentelo más tarde"))
                          )
                        }
                      });
                }

              },
          child:Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).appBarTheme.foregroundColor,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff121C4A).withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(5, 5),
                  ),
                ],
              ),
              child:
              Text(
                (_isSeguido)?"Dejar de Seguir":"Seguir",

                style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              )))),
    ]);
  }

  Widget drawContentList(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    InfoModel infoModel;
    infoModel = snapshot.data!["info"];
    totalPages = infoModel.pages;

    return
      Expanded(child:
      Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                Expanded(
                    child: buildList(snapshot))
              ]));
  }

  Widget buildList(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    var list = snapshot.data!["result"];

    list?.forEach((element) => {cardList.add(buildCard(element))});

    return ListView(controller: _scrollController, children: cardList);
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
              arguments: ScreenArguments(title, message, element.uid, from: "DETAIL_PAGE"));
        },
        child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: w * 0.25,
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
                      placeholder: (context, url) =>
                      const Center(
                          child: SpinKitFadingCircle(
                            color: Color(0xffb6b3c5),
                            size: 50.0,
                          )
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                          "assets/images/default.png"
                      ),
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
                        "$formatted | ${formatDurationString(element.duration)}",
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

    firebaseLogic.validateFavorite(uid, _deviceId).then(
            (value) => {
              setState(()=>{
                _isFavorito = value
              })
            });

    firebaseLogic.validateSeguido(uid, _deviceId).then(
            (value) => {
          setState(()=>{
            _isSeguido = value
          })
        });

  }

  String formatDurationString(String duration) {

    String formatted = duration;
    if(duration != null && duration.substring(0,2) == "00"){
      formatted = duration.substring(3);
    }else{
      formatted = "";
    }


    return formatted;
  }

}
