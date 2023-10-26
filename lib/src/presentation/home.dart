import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:radiounal/src/app.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';
import 'package:radiounal/src/business_logic/bloc/radio_destacados_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_programacion_bloc.dart';
import 'package:radiounal/src/data/models/episodio_model.dart';
import 'package:radiounal/src/data/models/programa_model.dart';
import 'package:radiounal/src/data/models/programacion_model.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/favorito_btn.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_destacados_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../business_logic/bloc/podcast_masescuchados_bloc.dart';
import '../business_logic/bloc/radio_masescuchados_bloc.dart';

class Home extends StatefulWidget {
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
      dynamic tipoParam,
      dynamic urlParam,
      bool isFrecuencia,
      FavoritoBtn? favoritoBtn)? callBackPlayMusic;
  List<ProgramacionModel> pragramacionList;

  Home(this.callBackPlayMusic, this.pragramacionList, {Key? key})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final blocRadioDestacados = RadioDestacadosBloc();
  final blocPodcastDestacados = PodcastDestacadosBloc();
  final blocRadioProgramacion = RadioProgramacionBloc();
  final blocRadioMasEscuchados = RadioMasEscuchadosBloc();
  final blocPodcastMasEscuchados = PodcastMasEscuchadosBloc();
  String potcastRandom = "";
  bool isDarkMode = false;

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

    blocPodcastDestacados.subject.stream.listen((event) {
      //Actualiza la transmision de podcast random
      EpisodioModel randomItem = (event..shuffle()).first;

      setState(() {
        potcastRandom = randomItem.audio;
      });
    });
  }

  Future<AdaptiveThemeMode?> themeMethod() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    return savedThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    themeMethod().then((value) {
      setState(() {
        isDarkMode = value == AdaptiveThemeMode.dark;
      });
    });

    return Scaffold(
        extendBodyBehindAppBar: true,
        endDrawer: const Menu(),
        appBar: AppBarRadio(enableBack: false),
        body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isDarkMode
                    ? "assets/images/FONDO_AZUL_REPRODUCTOR.png"
                    : "assets/images/fondo_blanco_amarillo.png"),
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
            ))));
  }

  @override
  void dispose() {
    blocRadioProgramacion.dispose();
    blocPodcastDestacados.dispose();
    blocRadioDestacados.dispose();
    blocRadioMasEscuchados.dispose();
    blocPodcastMasEscuchados.dispose();
    super.dispose();
  }

  Widget drawDestacados() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 140),
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
      color: Color(isDarkMode ? 0x00000000 : 0xFFFFFFFF),
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
                        // color:Color(isDarkMode?0xFFFCDC4D:0xff121C4A),
                        color: Color(isDarkMode ? 0xFFFFFFFF : 0xff121C4A),
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
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            drawFrecuenciaBtn("Bogotá\n98.5 fm",
                "http://streaming.unradio.unal.edu.co:8010/;stream.mp3"),
            drawFrecuenciaBtn("Medellín\n100.4 fm",
                "http://streaming.unradio.unal.edu.co:8012/;stream.mp3"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            drawFrecuenciaBtn("Radio web",
                "http://streaming.unradio.unal.edu.co:8014/;stream.mp3"),
            drawFrecuenciaBtn("Podcast", potcastRandom),
          ])
        ],
      ),
    );
  }

  Widget drawFavouriteBtn() {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      color: Color(isDarkMode ? 0x00000000 : 0xFFFFFFFF),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              gradient: RadialGradient(radius: 3, colors: [
                isDarkMode ? Color(0xffa6aabb) : Color(0xffFEE781),
                isDarkMode ? Color(0xffa6aabb) : Color(0xffFFCC17)
              ]),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff121C4A).withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(10, 10), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Color(0xff121C4A)),
            icon: const Icon(
              Icons.favorite,
              color: Color(0xff121C4A),
            ),
            onPressed: () async {
              Navigator.pushNamed(context, '/favourites',
                  arguments: ScreenArguments('NONE', 'NONE', 0));
            },
            label: const Text("Favoritos",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff121C4A),
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
                    child: Text(
                      "Programación",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              color:
                                  isDarkMode ? Colors.white : Color(0xff121C4A),
                              offset: const Offset(0, -5))
                        ],
                        color: Colors.transparent,
                        decorationThickness: 2,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decorationColor: const Color(0xFFFCDC4D),
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
      color: Color(isDarkMode ? 0x00000000 : 0xFFFFFFFF),
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
                        color: isDarkMode ? Colors.white : Color(0xFF121C4A),
                        offset: Offset(0, -5))
                  ],
                  color: Colors.transparent,
                  decorationThickness: 2,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decorationColor: const Color(0xFFFCDC4D),
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
    var marginBottom = MediaQuery.of(context).size.height.toDouble() * 0.10;

    return Container(
        margin: EdgeInsets.only(bottom: marginBottom, top: 10),
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 20, bottom: 10),
              child: Text(
                "Síguenos",
                style: TextStyle(
                  shadows: [
                    Shadow(
                        color:
                            isDarkMode ? Color(0xFFFFFFFF) : Color(0xFF121C4A),
                        offset: Offset(0, -5))
                  ],
                  color: Colors.transparent,
                  decorationThickness: 2,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decorationColor: const Color(0xFFFCDC4D),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: () async {
                    String fbProtocolUrl;
                    if (Platform.isIOS) {
                      fbProtocolUrl = 'fb://profile/208310195874854';
                    } else {
                      fbProtocolUrl = 'fb://page/208310195874854';
                    }

                    String fallbackUrl = 'https://www.facebook.com/RadioUNAL/';

                    try {
                      bool launched =
                          await launch(fbProtocolUrl, forceSafariVC: false);

                      if (!launched) {
                        await launch(fallbackUrl, forceSafariVC: false);
                      }
                    } catch (e) {
                      await launch(fallbackUrl, forceSafariVC: false);
                    }
                  },
                  child: SvgPicture.asset(
                    isDarkMode
                        ? 'assets/icons/facebook 1.svg'
                        : 'assets/icons/icono_facebook.svg',
                    width: MediaQuery.of(context).size.width * 0.14,
                  )),
              InkWell(
                  onTap: () {
                    _launchURL("https://www.instagram.com/radiounal/");
                  },
                  child: SvgPicture.asset(
                    isDarkMode
                        ? 'assets/icons/instagram 1.svg'
                        : 'assets/icons/icono_instagram_svg.svg',
                    width: MediaQuery.of(context).size.width * 0.14,
                  )),
              InkWell(
                  onTap: () {
                    _launchURL("https://twitter.com/radiounal");
                  },
                  child: SvgPicture.asset(
                    isDarkMode
                        ? 'assets/icons/twitter 1.svg'
                        : 'assets/icons/icono_twitter.svg',
                    width: MediaQuery.of(context).size.width * 0.14,
                  ))
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
    var list1 = snapshot1.data![0]; //Destacados de radio
    var list2 = snapshot1.data![1]; //Destacados de podcast

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
                    color: const Color(0xff121C4A)
                        .withOpacity(0.3),
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
                          padding: const EdgeInsets.only(left: 2, right: 2),
                          color: const Color(0xFFFCDC4D),
                          child: Text(
                            element.categoryTitle,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff121C4A),
                            ),
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
          widget.callBackPlayMusic!(0, urlFrecuencia, "", "", texto, "", "", "",
              "", "", "", true, null);
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
              gradient: RadialGradient(radius: 1, colors: [
                isDarkMode ? const Color(0xffFEE781) : const Color(0xff216278),
                isDarkMode ? const Color(0xffFFCC17) : const Color(0xff121C4A)
              ]),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff121C4A).withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(10, 10), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              texto,
              style: TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                  fontSize: 15),
            )));
  }

  Widget buildTableProgramacion(
      AsyncSnapshot<List<ProgramacionModel>> snapshot) {
    List<ProgramacionModel>? list = snapshot.data;

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEEE dd MMMM yyyy');
    final String formatted = formatter.format(now);

    List<Widget> rowList = [];
    var widthBox = 144.0;

    rowList.add(Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        width: widthBox * 4,
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFFA6AABB) : Color(0xFFCFCFCF),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: Center(
            child: Text(
          formatted[0].toUpperCase() + formatted.substring(1),
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xff121C4A)),
        ))));

    rowList.add(Row(children: [
      Container(
        padding: EdgeInsets.only(top: 3, bottom: 3),
        alignment: Alignment.center,
        color: const Color(0xfffcdc4d),
        width: widthBox,
        child: const Text(
          "",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 3, bottom: 3),
        alignment: Alignment.center,
        color: const Color(0xff121C4A),
        width: widthBox,
        child: const Text(
          "Ahora",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 3, bottom: 3),
        alignment: Alignment.center,
        color: const Color(0xfffcdc4d),
        width: widthBox,
        child: const Text("Siguiente",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xff121C4A))),
      ),
      Container(
          padding: const EdgeInsets.only(top: 3, bottom: 3),
          alignment: Alignment.center,
          color: const Color(0xff121C4A),
          width: widthBox,
          child: const Text(
            "Más Tarde",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ))
    ]));

    for (int i = 0; i < 3; i++) {
      rowList.add(
          Row(children: [
        Container(
            margin:  EdgeInsets.only(bottom: (i<2)?1:0),
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            width: widthBox,
            height: widthBox * 0.80,
            decoration: BoxDecoration(
              color: const Color(0xfffcdc4d),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular((i == 2) ? 30 : 0)),
            ),
            child: Text(
              "${list![i].emisora}\n${list[i].frecuencia}",
              style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff121C4A),
                  fontWeight: FontWeight.bold),
            )),
        Container(
            margin:  EdgeInsets.only(bottom: (i<2)?1:0),
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            width: widthBox,
            height: widthBox * 0.80,
            decoration: const BoxDecoration(
              color: Color(0xff121C4A),
            ),
            child: Text(
              "${list[i].ahorPrograma}\n${list[i].ahorHorario}",
              style: const TextStyle(color: Colors.white),
            )),
        Container(
            margin:  EdgeInsets.only(bottom: (i<2)?1:0),
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            width: widthBox,
            height: widthBox * 0.80,
            color: const Color(0xffFCDC4D),
            child: Text(
                "${list[i].siguientePrograma}\n${list[i].siguienteHorario}",
                style: const TextStyle(color: Color(0xff121C4A)))),
        Container(
            margin:  EdgeInsets.only(bottom: (i<2)?1:0),
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            width: widthBox,
            height: widthBox * 0.80,
            decoration: BoxDecoration(
              color: const Color(0xff121C4A),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular((i == 2) ? 30 : 0)),
            ),
            child: Text(
                "${list[i].masTardePrograma}\n${list[i].masTardeHorario}",
                style: const TextStyle(color: Colors.white)))
      ]));
    }

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
            child: Container(
                decoration: BoxDecoration(
                    color: isDarkMode?Colors.white:Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
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

    List<Widget> cardList1 = [];
    List<Widget> cardList2 = [];

    list1?.forEach(
        (element) => {cardList1.add(buildCardEscuchados(element, "Radio"))});

    list2?.forEach(
        (element) => {cardList2.add(buildCardEscuchados(element, "Podcast"))});

    // Mezcla listas
    List<Widget> listaMezclada = [];

    int longitudMaxima = cardList1.length > cardList2.length
        ? cardList1.length
        : cardList2.length;

    for (int i = 0; i < longitudMaxima; i++) {
      if (i < cardList1.length) {
        listaMezclada.add(cardList1[i]);
      }
      if (i < cardList2.length) {
        listaMezclada.add(cardList2[i]);
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listaMezclada,
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
                            color: Color(0xff121C4A).withOpacity(0.3),
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
                    padding: EdgeInsets.only(left: 2, right: 2),
                    margin: const EdgeInsets.only(top: 15),
                    color: Color(0xFFFCDC4D),
                    child: Text(
                      element.categoryTitle,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF121C4A)),
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(element.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFF121C4A),
                              fontWeight: FontWeight.bold))),
                  Container(
                    child: Text(
                      site,
                      style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode
                              ? Colors.white
                              : Color(0xFF121C4A),
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    child: Text(
                      "$formatted ${formatDurationString(element.duration)}",
                      style: TextStyle(
                          fontSize: 9,
                          color: isDarkMode
                              ? Colors.white
                              : Color(0xFF121C4A)),
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

  String formatDurationString(String duration) {
    String formatted = "";
    if (duration != null && duration.trim() != "") {
      if (duration.substring(0, 2) == "00") {
        formatted = "| " + duration.substring(3);
      } else {
        formatted = "| " + duration;
      }
    }

    return formatted;
  }
}
