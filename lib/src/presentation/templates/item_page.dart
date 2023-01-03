import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_episodio_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_emision_bloc.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class ItemPage extends StatefulWidget {

  final String title;
  final String message;
  final int uid; //Indica el id del episodio de podcast o emisora de radio

  const ItemPage({Key? key, required this.title, required this.message, required this.uid}) : super(key: key);


  @override
  State<ItemPage> createState() => _ItemPageState();

}

class _ItemPageState extends State<ItemPage> {
  late String title;
  late String message;
  late int uid;

  final blocRadioEmision = RadioEmisionBloc();
  final blocPodcastEpisodio = PodcastEpisodioBloc();
  late dynamic element =  null;


  @override
  void initState() {
    super.initState();

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';

    title = widget.title;
    message = widget.message;
    uid = widget.uid;

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

  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      drawer: Menu(),
      appBar: AppBarRadio(),
      body: Center(
        child: Column(children:[
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
    var w = MediaQuery.of(context).size.width;
    final DateTime now =
    DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(element.date);
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(now);

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
                //TODO: Comopartir url
                print("COMPARTIR URL");
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
              imageUrl: (element.imagen!=null)?element.imagen:"",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Container(
                  height: w * 0.25,
                  color: Theme.of(context).primaryColor,
                  child: Image.asset("assets/images/logo.png")),
            ),
          )),
      Container(
        alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        margin: const EdgeInsets.only(left: 20, top: 30),
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
              fontSize: 14, fontWeight: FontWeight.bold),
        ),
      )),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Text(
          element.title,
          style: const TextStyle(
            color: Color(0xff121C4A),
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 20),
        child: Text(
          formatted,
          style: const TextStyle(
              fontSize: 10, color: Color(0xff666666)),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Text(
          (element=="RADIO")?element.description:element.teaser,
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
          ))
    ]);
  }
  Widget drawContentBtns(dynamic element){
    var w = MediaQuery.of(context).size.width;

    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: InkWell(
              onTap: (){
                //TODO: Reproducir audio
                print(element.audio);
              },
              child:Container(
                  width: w * 0.35,
                  padding: const EdgeInsets.only(left: 10, right: 10),

                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                        radius: 1, colors: [
                      Colors.white54.withOpacity(0.3),
                      const Color(0xff121C4A),
                    ]),
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).primaryColor,
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
                  Row(children: const [
                    Icon(Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                    Text(
                      "Reproducir",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16
                      ),
                    )],)
              ))),
      Container(
        margin: const EdgeInsets.only(top:20),
        child: Row(children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: InkWell(
                  onTap: (){
                    //TODO: Descargar mp3
                    print(element.audio);
                  },
                  child:Container(

                      padding: const EdgeInsets.only(left: 10, right: 10),

                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                            radius: 1, colors: [
                          Colors.white54.withOpacity(0.3),
                          const Color(0xffFCDC4D)
                        ]),
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
                      child: const Icon(Icons.download,
                        size: 40,
                      )
                  ))),
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: InkWell(
                  onTap: (){
                    //TODO: Descargar RSS
                    print(element.pdf);
                  },
                  child:Container(

                      padding: const EdgeInsets.only(left: 10, right: 10),

                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                            radius: 1, colors: [
                          Colors.white54.withOpacity(0.3),
                          const Color(0xffFCDC4D)
                        ]),
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
                      const Icon(Icons.wifi,
                        size: 40,
                      )
                  ))),
          if(message=="PODCAST")
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: InkWell(
                    onTap: (){
                      //TODO: Descargar transcripcion
                      print(element.pdf);
                    },
                    child:Container(

                        padding: const EdgeInsets.only(left: 10, right: 10),

                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                              radius: 1, colors: [
                            Colors.white54.withOpacity(0.3),
                            const Color(0xffFCDC4D)
                          ]),
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
                        Row(children: const [
                          Icon(Icons.arrow_downward,
                            size: 40,
                          ),
                          Text(
                            "Transcripción",
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 17
                            ),
                          )],)
                    ))),

        ],),
      )
    ]);
  }

}


