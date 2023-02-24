import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:radiounal/src/business_logic/bloc/elastic_search_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_search_bloc.dart';
import 'package:radiounal/src/data/models/episodio_model.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:rxdart/rxdart.dart';

import '../../business_logic/ScreenArguments.dart';
import '../../business_logic/bloc/podcast_masescuchados_bloc.dart';
import '../../business_logic/bloc/podcast_search_bloc.dart';
import '../../business_logic/bloc/podcast_series_bloc.dart';
import '../../business_logic/bloc/radio_masescuchados_bloc.dart';
import '../../data/models/info_model.dart';

class BrowserResultPage extends StatefulWidget {
  String title;
  String message;
  dynamic element;
  late int page;

  BrowserResultPage(
      {Key? key,
      required this.title,
      required this.message,
      required this.page,
      this.element})
      : super(key: key);

  @override
  State<BrowserResultPage> createState() => _BrowserResultPageState();
}

class _BrowserResultPageState extends State<BrowserResultPage> {
  late String title;
  late String message;
  dynamic elementFilters;
  late int page;

  final blocRadioSearch = RadioSearchBloc();
  final blocRadioMasEscuchados = RadioMasEscuchadosBloc();
  final blocPodcastMasEscuchados = PodcastMasEscuchadosBloc();
  final blocPodcastSeries = PodcastSeriesBloc();
  final blocElasticSearch = ElasticSearchBloc();
  final blocPodcastSearch = PodcastSearchBloc();

  var size = null;
  double paddingTop = 0;
  ScrollController _scrollController = ScrollController();
  var querySize = 0;
  var start = 0;

  @override
  void initState() {
    title = widget.title;
    message = widget.message;
    elementFilters = widget.element;
    page = widget.page;


    if (elementFilters["contentType"] == "MASESCUCHADO") {
      blocRadioMasEscuchados.fetchMasEscuchados();
      blocPodcastMasEscuchados.fetchMasEscuchados();
    } else if (elementFilters["contentType"] == "PROGRAMAS" ||
        elementFilters["contentType"] == "EMISIONES") {
      blocRadioSearch.fetchSearch(
          elementFilters["query"],
          page,
          elementFilters["sede"],
          elementFilters["canal"],
          elementFilters["area"],
          elementFilters["contentType"]);
    } else if (elementFilters["contentType"] == "SERIES") {
      blocPodcastSeries.fetchSeries(page);
    } else if (elementFilters["contentType"] == "EPISODIOS") {
      blocPodcastSearch.fetchSearch(elementFilters["query"],page);
    }else if (elementFilters["contentType"] == "ELASTIC") {
      querySize = 10;
      start = page * querySize;
      blocElasticSearch.fetchSearch(elementFilters["query"], page, start);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    paddingTop = size.width * 0.30;

    return Scaffold(
      drawer: Menu(),
      appBar: AppBarRadio(),
      body:
      DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fondo_blanco_amarillo.png"),
              fit: BoxFit.cover,
            ),
          ),
          child:
      drawContent()),
      //bottomNavigationBar: BottomNavigationBarRadio(),
    );
  }

  @override
  void dispose() {
    blocRadioSearch.dispose();
    blocRadioMasEscuchados.dispose();
    blocPodcastMasEscuchados.dispose();
    blocPodcastSeries.dispose();
    blocElasticSearch.dispose();
    blocPodcastSearch.dispose();

    super.dispose();
  }

  Widget drawContent() {
    Widget widget;

    if (elementFilters["contentType"] == "MASESCUCHADO") {
      widget = StreamBuilder(
          stream: CombineLatestStream.list([
            blocRadioMasEscuchados.subject.stream,
            blocPodcastMasEscuchados.subject.stream,
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            Widget child;

            if (snapshot.hasData) {
              child = buildListEscuchados(snapshot);
            } else if (snapshot.hasError) {
              child = drawError(snapshot.error);
            } else {
              child = const Center(child: CircularProgressIndicator());
            }
            return child;
          });
    }else if (elementFilters["contentType"] == "ELASTIC") {
      widget = StreamBuilder(
          stream: blocElasticSearch.subject.stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Widget child;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              child = drawContentList(snapshot);
            } else if (snapshot.hasError) {
              child = drawError(snapshot.error);
            } else {
              child = const Center(child: CircularProgressIndicator());
            }
            return child;
          });
    } else {
      var blocStream = null;
      if(elementFilters["contentType"] == "SERIES"){
        blocStream = blocPodcastSeries.subject.stream;
      }else if(elementFilters["contentType"] == "EPISODIOS"){
        blocStream = blocPodcastSearch.subject.stream;
      }else{
        blocStream = blocRadioSearch.subject.stream;
      }
      widget = StreamBuilder(
          stream: blocStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Widget child;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              child = drawContentList(snapshot);
            } else if (snapshot.hasError) {
              child = drawError(snapshot.error);
            } else {
              child = const Center(child: CircularProgressIndicator());
            }
            return child;
          });
    }

    return widget;
  }

  Widget drawContentList(AsyncSnapshot<dynamic> snapshot) {
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
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    message,
                    style: TextStyle(
                      shadows: [
                        Shadow(
                            color: Theme.of(context).primaryColor,
                            offset: const Offset(0, -5))
                      ],
                      color: Colors.transparent,
                      decorationThickness: 2,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decorationColor: const  Color(0xFFFCDC4D),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
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

                        if (elementFilters["contentType"] == "PROGRAMAS" || elementFilters["contentType"] == "EMISIONES") {
                          blocRadioSearch.subject.sink.add(null);
                          blocRadioSearch.fetchSearch(
                              elementFilters["query"],
                              page,
                              elementFilters["sede"],
                              elementFilters["canal"],
                              elementFilters["area"],
                              elementFilters["contentType"]);
                        } else if (elementFilters["contentType"] == "ELASTIC") {

                          start = page * querySize;
                          blocElasticSearch.fetchSearch(
                              elementFilters["query"], page, start);
                        } else if(elementFilters["contentType"] == "SERIES"){
                          blocPodcastSeries.fetchSeries(page);
                        }else if (elementFilters["contentType"] == "EPISODIOS") {
                          blocPodcastSearch.fetchSearch(elementFilters["query"],page);
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
              top: (page == 1) ? (size.width * 0.2) : (size.width * 0.3),
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


                if (elementFilters["contentType"] == "PROGRAMAS" || elementFilters["contentType"] == "EMISIONES") {
                  blocRadioSearch.subject.sink.add(null);
                  blocRadioSearch.fetchSearch(
                      elementFilters["query"],
                      page,
                      elementFilters["sede"],
                      elementFilters["canal"],
                      elementFilters["area"],
                      elementFilters["contentType"]);
                } else if (elementFilters["contentType"] == "ELASTIC") {
                  start = page * querySize;
                  blocElasticSearch.fetchSearch(
                      elementFilters["query"], page, start);
                } else if(elementFilters["contentType"] == "SERIES"){
                  blocPodcastSeries.fetchSeries(page);
                }else if (elementFilters["contentType"] == "EPISODIOS") {
                  blocPodcastSearch.fetchSearch(elementFilters["query"],page);
                }

              },
              child: Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  width: size.width,
                  height: size.width * 0.1,
                  color: Colors.white,
                  child: Image.asset("assets/icons/arrow_page.png")),
            ))
    ]);
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

  Widget buildList(AsyncSnapshot<dynamic> snapshot) {
    var list = snapshot.data!["result"];

    List<Widget> cardList = [];
    list?.forEach((element) => {cardList.add(buildCard(element))});

    return GridView.count(
        controller: _scrollController, crossAxisCount: 2, children: cardList);
  }

  Widget buildCard(element) {
    print(element);
    var w = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: () {

          if(elementFilters["contentType"] == "SERIES") {
            Navigator.pushNamed(context, "/detail",
                arguments: ScreenArguments(
                    "SITE",
                    "PODCAST",
                    element.uid,
                    element: element
                ));
          }else if(elementFilters["contentType"] == "PROGRAMAS"){
            Navigator.pushNamed(context, "/detail",
                arguments: ScreenArguments(
                    "SITE",
                    "RADIO",
                    element.uid,
                    element: element
                ));
          }else if(elementFilters["contentType"] == "EMISIONES"){
            Navigator.pushNamed(context, "/item",
                arguments: ScreenArguments(
                    "SITE",
                    "RADIO",
                    element.uid,
                    element: element
                ));
          }else if(elementFilters["contentType"] == "EPISODIOS"){
            Navigator.pushNamed(context, "/item",
                arguments: ScreenArguments(
                    "SITE",
                    "PODCAST",
                    element.uid,
                    from: "BROWSER_RESULT_PAGE"
                ));
          }else if(elementFilters["contentType"] == "MASESCUCHADO"){

            Navigator.pushNamed(context, "/item",
                arguments: ScreenArguments(
                    "SITE",
                    (element is EpisodioModel)?"PODCAST":"RADIO",
                    element.uid,
                    from: "BROWSER_RESULT_PAGE"
                ));
          }

        },
        child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
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
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      //fit: BoxFit.cover,
                      imageUrl: (elementFilters["contentType"] == "ELASTIC")
                          ? element["_source"]["imagen"]
                          : element.imagen,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Container(
                          height: w * 0.25,
                          color: Theme.of(context).primaryColor,
                          child: Image.asset("assets/images/logo.png")),
                    ),
                  ),
                )),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff121C4A).withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset:
                            const Offset(5, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    (elementFilters["contentType"] == "ELASTIC")
                        ? element["_source"]["title"] ?? ""
                        : element.title,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )));
  }

  Widget buildListEscuchados(AsyncSnapshot<List<dynamic>> snapshot1) {
    var list1 = snapshot1.data![0];
    var list2 = snapshot1.data![1];

    List<Widget> cardList = [];

    list1?.forEach((element) => {cardList.add(buildCard(element))});

    list2?.forEach((element) => {cardList.add(buildCard(element))});

    return GridView.count(
        controller: _scrollController, crossAxisCount: 2, children: cardList);
  }
}
