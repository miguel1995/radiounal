import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_episodios_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_seriesyepisodios_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_programasyemisiones_bloc.dart';
import 'package:radiounal/src/data/models/info_model.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../business_logic/bloc/radio_emisiones_bloc.dart';
import 'package:share_plus/share_plus.dart';

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

  @override
  void initState() {
    super.initState();

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';

    title = widget.title;
    message = widget.message;
    uid = widget.uid;
    page = 1;
    elementContent = widget.elementContent;

    print("$title $message $uid $elementContent");

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

          print(event["series"][0]);

          if(event["series"]!=null){
            if(event["series"].length > 0){
              print(event["series"][0]);
              setState((){
                elementContent = event["series"][0];
              });

            }
          }
        });      }
    }

  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    paddingTop = size.width * 0.30;

    return Scaffold(
        drawer: Menu(),
        appBar: AppBarRadio(),
        body: StreamBuilder(
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
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: drawContentDescription(elementContent)),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: drawContentList(snapshot))
                  ],
                );
              } else if (snapshot.hasError) {
                child = drawError(snapshot.error);
              } else {
                child = Container(
                    //child: Text("en progreso..."),
                    );
              }
              return child;
            })
        //bottomNavigationBar: BottomNavigationBarRadio(),
        );
  }

  @override
  void dispose() {
    blocPodcastEpisodios.dispose();
    blocRadioEmisiones.dispose();
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
                //TODO: AGREGAR FAVORITO A LA BASE DE DATOS EN FIREBASE
                print("FAVORITOS");
              },
              child: Container(
              padding: const EdgeInsets.only(left: 3, right: 3),
              child: const Icon(Icons.favorite_border))
          ),
          InkWell(
              onTap: (){
                Share.share(element.url, subject: "Radio UNAL - ${element.title}");
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
              imageUrl: element.imagen,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Container(
                  height: w * 0.25,
                  color: Theme.of(context).primaryColor,
                  child: Image.asset("assets/images/logo.png")),
            ),
          )),
      Container(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Text(
          element.title,
          style: const TextStyle(
            color: Color(0xff121C4A),
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
              full: SvgPicture.asset('assets/icons/star.svg'),
              half: SvgPicture.asset('assets/icons/star.svg'),
              empty: SvgPicture.asset('assets/icons/star_border.svg'),
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
                //TODO: Llamar al metodo de agragar programa seguido en Firebase y notificaciones
                print("AGREGAR A LISTADO DE SEGUIDOS");
              },
          child:Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
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
              const Text(
                "Seguir",
                style: TextStyle(fontWeight: FontWeight.bold),
              )))),
    ]);
  }

  Widget drawContentList(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    InfoModel infoModel;
    infoModel = snapshot.data!["info"];

    return Stack(children: [
      Positioned(
          top: 0,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "${infoModel.count} resultados",
                    style: const TextStyle(
                      color: Color(0xff121C4A),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      decorationColor: Color(0xFFFCDC4D),
                    ),
                  ),
                ),
                Container(
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
                ),
                if (page > 1)
                  InkWell(
                      onTap: () {
                        setState(() {
                          page--;
                        });
                        _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                        if (message == "RADIO") {
                          blocRadioEmisiones.fetchEmisiones(uid, page);
                        } else {
                          blocPodcastEpisodios.fetchEpisodios(uid, page);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        width: size.width,
                        height: size.width * 0.1,
                        child: Transform.rotate(
                            angle: 180 * pi / 180,
                            child: Image.asset("assets/icons/arrow_page.png")),
                      ))
              ])),
      Container(
          padding: EdgeInsets.only(
              top: (page == 1) ? (size.width * 0.1) : (size.width * 0.16),
              bottom: (page == infoModel.pages) ? 0 : (size.width * 0.1)),
          child: buildList(snapshot)),
      if (page < infoModel.pages)
        Positioned(
            bottom: 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  page++;
                });

                _scrollController.animateTo(
                    _scrollController.position.minScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
                if (message == "RADIO") {
                  blocRadioEmisiones.fetchEmisiones(uid, page);
                } else {
                  blocPodcastEpisodios.fetchEpisodios(uid, page);
                }
              },
              child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  width: size.width,
                  height: size.width * 0.1,
                  child: Image.asset("assets/icons/arrow_page.png")),
            ))
    ]);
  }

  Widget buildList(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    var list = snapshot.data!["result"];

    List<Widget> cardList = [];
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
              arguments: ScreenArguments(title, message, element.uid));
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
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Container(
                          height: w * 0.25,
                          color: Theme.of(context).primaryColor,
                          child: Image.asset("assets/images/logo.png")),
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
                            fontSize: 10, fontWeight: FontWeight.bold),
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
                        formatted,
                        style: const TextStyle(
                            fontSize: 8, color: Color(0xff666666)),
                      ),
                    )
                  ]))
            ])));
  }
}
