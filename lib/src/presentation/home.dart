import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';
import 'package:radiounal/src/business_logic/bloc/radio_destacados_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_programacion_bloc.dart';
import 'package:radiounal/src/data/models/programacion_model.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_destacados_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../business_logic/bloc/podcast_masescuchados_bloc.dart';
import '../business_logic/bloc/radio_masescuchados_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final blocRadioDestacados = RadioDestacadosBloc();
  final blocPodcastDestacados = PodcastDestacadosBloc();
  final blocRadioProgramacion = RadioProgramacionBloc();
  final blocRadioMasEscuchados = RadioMasEscuchadosBloc();
  final blocPodcastMasEscuchados = PodcastMasEscuchadosBloc();
  final GlobalKey<BottomNavigationBarRadioState> _key = GlobalKey();


  @override
  void initState() {
    super.initState();

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';

    blocRadioDestacados.fetchDestacados();
    blocPodcastDestacados.fetchDestacados();
    blocRadioProgramacion.fetchProgramacion();
    blocRadioMasEscuchados.fetchMasEscuchados();
    blocPodcastMasEscuchados.fetchMasEscuchados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Menu(),
        appBar: const AppBarRadio(),
        body: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fondo_blanco_amarillo.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
                child: Column(
              children: [
                drawDestacados(),
                drawFrecuencias(),
                drawFavouriteBtn(),
                drawProgramacion(),
                drawMasEscuchado(),
                drawSiguenos()
              ],


            ))),
      bottomNavigationBar:  BottomNavigationBarRadio(
        key: _key
      )
    );
  }

  @override
  void dispose() {
    blocRadioProgramacion.dispose();
    blocPodcastDestacados.dispose();
    blocRadioDestacados.dispose();
    super.dispose();
  }

  Widget drawDestacados() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 40),
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child: StreamBuilder(
          stream: CombineLatestStream.list([
            blocRadioDestacados.subject.stream,
            blocPodcastDestacados.subject.stream,
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot1) {
            Widget child;

            if (snapshot1.hasData) {
              child = buildListDestacados(snapshot1);
            } else if (snapshot1.hasError) {
              child = drawError(snapshot1.error);
            } else {
              child = Container(
                  //child: Text("en progreso..."),
                  );
            }
            return child;
          }),
    );
  }

  Widget drawFrecuencias() {
    return Container(
      padding: const EdgeInsets.only(left: 0),
      color: const Color(0xffEEEEEE),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
              child: Text(
                "Escuchanos en",
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
                  decorationColor: Color(0xffFCDC4D),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            drawFrecuenciaBtn("Bogotá\n98.5 fm", "http://streaming.unradio.unal.edu.co:8010/;stream.mp3"),
            drawFrecuenciaBtn("Medellín\n100.4 fm", "http://streaming.unradio.unal.edu.co:8012/;stream.mp3"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            drawFrecuenciaBtn("Radio web", "http://streaming.unradio.unal.edu.co:8014/;stream.mp3"),
            drawFrecuenciaBtn("Podcast", "http://streaming.unradio.unal.edu.co:8014/;stream.mp3"),
          ])
        ],
      ),
    );
  }

  Widget drawFavouriteBtn() {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: const Color(0xffEEEEEE),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(

              gradient: const RadialGradient(radius: 2, colors: [
                Color(0xffFCDC4D),
                Color(0xffFFCC17 )
              ]),

              boxShadow: [
            BoxShadow(
              color: const Color(0xff121C4A).withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(10, 10), // changes position of shadow
            ),
          ], borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Theme.of(context).primaryColor),
            icon: const Icon(Icons.favorite),
            onPressed: () async {
              Navigator.pushNamed(context, '/favourites',
                  arguments: ScreenArguments('NONE', 'NONE', 0));
            },
            label: Text("Favoritos",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget drawProgramacion() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: StreamBuilder(
          stream: blocRadioProgramacion.subject.stream,
          builder: (BuildContext context,
              AsyncSnapshot<List<ProgramacionModel>> snapshot) {
            Widget child;

            if (snapshot.hasData) {
              child = Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.only(top: 20, bottom: 20, left: 20),
                    child:  Text(
                      "Programación",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              color: Theme.of(context).primaryColor,
                              offset: Offset(0, -5))
                        ],
                        color: Colors.transparent,
                        decorationThickness: 2,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decorationColor: Color(0xffFCDC4D),
                        decoration: TextDecoration.underline,

                      ),
                    ),
                  ),
                ),
                buildTableProgramacion(snapshot)
              ]);
            } else if (snapshot.hasError) {
              child = drawError(snapshot.error);
            } else {
              child = Container(
                  //child: Text("en progreso..."),
                  );
            }

            return child;
          }),
    );
  }

  Widget drawMasEscuchado() {
    return Container(
      color: const Color(0xffEEEEEE),
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 20, bottom: 10),
              child: Text(
                "Lo más escuchado",
                style: TextStyle(
                  shadows: [
                    Shadow(
                        color: Theme.of(context).primaryColor,
                        offset: Offset(0, -5))
                  ],
                  color: Colors.transparent,
                  decorationThickness: 2,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decorationColor: Color(0xffFCDC4D),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: CombineLatestStream.list([
                blocRadioMasEscuchados.subject.stream,
                blocPodcastMasEscuchados.subject.stream,
              ]),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                Widget child;

                if (snapshot.hasData) {
                  child = buildListEscuchados(snapshot);
                } else if (snapshot.hasError) {
                  child = drawError(snapshot.error);
                } else {
                  child = Container(
                      //child: Text("en progreso..."),
                      );
                }
                return child;
              })
        ],
      ),
    );
  }

  Widget drawSiguenos() {
    return Container(
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 20, bottom: 10),
              child:  Text(
                "Síguenos",
                style: TextStyle(
                  shadows: [
                    Shadow(
                        color: Theme.of(context).primaryColor,
                        offset: Offset(0, -5))
                  ],
                  color: Colors.transparent,
                  decorationThickness: 2,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decorationColor: Color(0xffFCDC4D),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: () {
                    _launchURL("https://www.facebook.com/RadioUNAL/");
                  },
                  child: SvgPicture.asset(
                    'assets/icons/icono_facebook.svg',
                    width: MediaQuery.of(context).size.width * 0.18,
                  )),
              InkWell(
                  onTap: () {
                    _launchURL("https://www.instagram.com/radiounal/");
                  },
                  child: SvgPicture.asset(
                      'assets/icons/icono_instagram_svg.svg',
                      width: MediaQuery.of(context).size.width * 0.18)),
              InkWell(
                  onTap: () {
                    _launchURL("https://twitter.com/radiounal");
                  },
                  child: SvgPicture.asset('assets/icons/icono_twitter.svg',
                      width: MediaQuery.of(context).size.width * 0.18))
            ],
          )
        ]));
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

  Widget buildListDestacados(AsyncSnapshot<List<dynamic>> snapshot1) {
    var list1 = snapshot1.data![0];
    var list2 = snapshot1.data![1];

    List<Widget> cardList = [];

    list1?.forEach((element) => {cardList.add(buildCard(element, "RADIO"))});

    list2?.forEach((element) => {cardList.add(buildCard(element, "PODCAST"))});

    return CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.width * 0.5,
          enlargeCenterPage: true,
          viewportFraction: 0.5,
        ),
        items: cardList);
  }

  Widget buildCard(element, siteName) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/item",
              arguments: ScreenArguments("SITE", siteName, element.uid,
                  from: "HOME_PAGE"));
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff121C4A).withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(10, 10), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                image: DecorationImage(
                  image: NetworkImage(element.imagen),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    color: const Color(0xff121C4A).withOpacity(0.3),
                  ),
                ),
                Positioned(
                    bottom: 15,
                    left: 15,
                    right: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              element.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: const TextStyle(color: Colors.white),
                            )),
                        Container(
                          color: const Color(0xffFCDC4D),
                          child: Text(
                            element.categoryTitle,
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ))
              ])),
        ));
  }

  Widget drawFrecuenciaBtn(String texto, String urlFrecuencia) {
    var widthBox = MediaQuery.of(context).size.width * 0.35;
    return InkWell(
        onTap: () {
          _key.currentState!.playMusic(
              urlFrecuencia,
              "",
              "",
              texto,
              "",
              "",
              "",
              true
          );
        },

        child: Container(
            alignment: Alignment.center,
            width: widthBox,
            height: widthBox * 0.6,
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: const RadialGradient(
                  radius: 1, colors: [
                    Color( 0xff216278), Color(0xff121C4A)
              ]),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff121C4A).withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(10, 10), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              texto,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            )
        ));
  }

  Widget buildTableProgramacion(
      AsyncSnapshot<List<ProgramacionModel>> snapshot) {
    List<ProgramacionModel>? list = snapshot.data;

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE dd MMMM yyyy');
    final String formatted = formatter.format(now);

    List<Widget> rowList = [];
    var widthBox = MediaQuery.of(context).size.width * 0.35;

    rowList.add(Container(
      padding: const EdgeInsets.only(top:5, bottom: 5),
        width: widthBox * 4,
        decoration: const BoxDecoration(
          color: Color(0xffCFCFCF),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: Center(
            child: Text(
              formatted[0].toUpperCase() + formatted.substring(1),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ))));

    rowList.add(Row(children: [
      Container(
        alignment: Alignment.center,
        color: Theme.of(context).appBarTheme.foregroundColor,
        width: widthBox,
        child: const Text(
          "",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
        width: widthBox,
        child: const Text(
          "Ahora",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      Container(
        alignment: Alignment.center,
        color: Theme.of(context).appBarTheme.foregroundColor,
        width: widthBox,
        child: const Text("Siguiente",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      Container(
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor,
          width: widthBox,
          child: const Text(
            "Más Tarde",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ))
    ]));

    for (int i = 0; i < 3; i++) {
      rowList.add(Row(children: [
        Container(
            margin: const EdgeInsets.only(bottom: 1),
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            width: widthBox,
            height: widthBox * 0.80,
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.foregroundColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular((i == 2) ? 30 : 0)),
            ),
            child: Text(
              "${list![i].emisora}\n${list[i].frecuencia}",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            )),
        Container(
            margin: const EdgeInsets.only(bottom: 1),
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            width: widthBox,
            height: widthBox * 0.80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              "${list[i].ahorPrograma}\n${list[i].ahorHorario}",
              style: TextStyle(color: Colors.white),
            )),
        Container(
            margin: const EdgeInsets.only(bottom: 1),
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            width: widthBox,
            height: widthBox * 0.80,
            color: Theme.of(context).appBarTheme.foregroundColor,
            child: Text(
                "${list[i].siguientePrograma}\n${list[i].siguienteHorario}",
                style: TextStyle(color: Theme.of(context).primaryColor))),
        Container(
            margin: const EdgeInsets.only(bottom: 1),
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            width: widthBox,
            height: widthBox * 0.80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular((i == 2) ? 30 : 0)),
            ),
            child: Text(
                "${list[i].masTardePrograma}\n${list[i].masTardeHorario}",
                style: TextStyle(color: Colors.white)))
      ]));
    }

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff121C4A).withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset:
                            const Offset(10, 10), // changes position of shadow
                      ),
                    ]),
                child: Column(children: rowList))));
  }

  Widget buildListEscuchados(AsyncSnapshot<List<dynamic>> snapshot1) {
    var list1 = snapshot1.data![0];
    var list2 = snapshot1.data![1];

    List<Widget> cardList = [];

    list1?.forEach(
        (element) => {cardList.add(buildCardEscuchados(element, "Radio"))});

    list2?.forEach(
        (element) => {cardList.add(buildCardEscuchados(element, "Podcast"))});

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cardList,
      ),
    );
  }

  Widget buildCardEscuchados(element, String site) {
    final DateTime now =
        DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(element.date);
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(now);

    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/item",
              arguments: ScreenArguments(
                  "SITE", site.toUpperCase(), element.uid,
                  from: "HOME_PAGE"));
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.40,
          child: Container(
              margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff121C4A).withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(
                                10, 10), // changes position of shadow
                          ),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image(image: NetworkImage(element.imagen)))),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    color: const Color(0xffFCDC4D),
                    child: Text(
                      element.categoryTitle,
                      style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(element.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold))),
                  Container(
                    child: Text(
                      site,
                      style: TextStyle(
                          fontSize: 9,
                          color: Theme.of(context).primaryColor,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    child: Text(
                      formatted,
                      style: const TextStyle(
                          fontSize: 8, color: Color(0xff666666)),
                    ),
                  ),
                ],
              )),
        ));
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}
