import 'dart:math';

import 'package:flutter/material.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_series_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_programas_bloc.dart';
import 'package:radiounal/src/data/models/info_model.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContentPage extends StatefulWidget {
  final String title;
  final String message;
  final int page;

  const ContentPage(
      {Key? key,
      required this.title,
      required this.message,
      required this.page})
      : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late String title;
  late String message;
  late int page;

  final blocRadioProgramas = RadioProgramasBloc();
  final blocPodcastSeries = PodcastSeriesBloc();

  var size = null;
  double paddingTop = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    title = widget.title;
    message = widget.message;
    page = widget.page;

    if (message == "RADIO") {
      blocRadioProgramas.fetchProgramas(page);
    } else if (message == "PODCAST") {
      blocPodcastSeries.fetchSeries(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    paddingTop = size.width * 0.30;

    return Scaffold(
      drawer: const Menu(),
      appBar: const AppBarRadio(),
      body: StreamBuilder(
          stream: (message == "RADIO")
              ? blocRadioProgramas.subject.stream
              : blocPodcastSeries.subject.stream,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            Widget child;

            if (snapshot.hasData) {
              child = drawContentList(snapshot);
            } else if (snapshot.hasError) {
              child = drawError(snapshot.error);
            } else {
              child = Container(
                  //child: Text("en progreso..."),
                  );
            }
            return child;
          }),
      //bottomNavigationBar: const BottomNavigationBarRadio(),
    );
  }

  @override
  void dispose() {
    blocPodcastSeries.dispose();
    blocRadioProgramas.dispose();
    super.dispose();
  }



  Widget drawContentList(AsyncSnapshot<Map<String, dynamic>> snapshot){
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
                    (message == "RADIO")
                        ? ("Programas Radio UNAL")
                        : ("Series Podcast Radio UNAL"),
                    style: const TextStyle(
                      color: Color(0xff121C4A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decorationColor: Color(0xFFFCDC4D),
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
                    "P??gina ${page} de ${infoModel.pages}",
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
                            _scrollController
                                .position.minScrollExtent,
                            duration:
                            const Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                        if (message == "RADIO") {
                          blocRadioProgramas.fetchProgramas(page);
                        } else {
                          blocPodcastSeries.fetchSeries(page);
                        }
                      },
                      child: Container(
                        padding:
                        const EdgeInsets.only(top: 5, bottom: 5),
                        width: size.width,
                        height: size.width * 0.1,
                        child: Transform.rotate(
                            angle: 180 * pi / 180,
                            child: Image.asset(
                                "assets/icons/arrow_page.png")),
                      ))
              ])),
      Container(
          padding: EdgeInsets.only(
              top: (page == 1)
                  ? (size.width * 0.2)
                  : (size.width * 0.3),
              bottom:
              (page == infoModel.pages) ? 0 : (size.width * 0.1)),
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
                  blocRadioProgramas.fetchProgramas(page);
                } else {
                  blocPodcastSeries.fetchSeries(page);
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

  Widget buildList(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    var list = snapshot.data!["result"];

    List<Widget> cardList = [];
    list?.forEach((element) => {cardList.add(buildCard(element))});

    return GridView.count(
        controller: _scrollController, crossAxisCount: 2, children: cardList);
  }

  Widget buildCard(element) {
    var w = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/detail",
              arguments: ScreenArguments(
                  title,
                  message,
                  element.uid,
                  element: element
              ));
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
                      imageUrl: element.imagen,
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
                    element.title,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )));
  }
}
