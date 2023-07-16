import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:radiounal/src/business_logic/bloc/radio_search_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_search_series_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_search_bloc.dart';
import 'package:radiounal/src/data/models/info_model.dart';
import '../../business_logic/ScreenArguments.dart';
import '../../business_logic/bloc/radio_search_programas_bloc.dart';
import '../../data/models/episodio_model.dart';


class MultiTabResult extends StatefulWidget {

  int tabIndex;
  String query;
  int page;
  int sede;
  String canal;
  String area;

  MultiTabResult({Key? key, required this.tabIndex, required String this.query, required int this.page, required int this.sede, required String this.canal, required String this.area}) : super(key: key);

  @override
  State<MultiTabResult> createState() => _MultiTabResultState();
}

class _MultiTabResultState extends State<MultiTabResult> with TickerProviderStateMixin{

  late TabController _tabController;
  int tabIndex = 0;
  String query = "";
  int _sede = 0;
  String _canal = "TODOS";
  String _area = "TODOS";

  late int pageSeries = 0;
  int totalPagesSeries = 0;
  bool isLoadingSeries = false;

  late int pageEpisodios = 0;
  int totalPagesEpisodios = 0;
  bool isLoadingEpisodios = false;

  late int pageProgramas = 0;
  int totalPagesProgramas = 0;
  bool isLoadingProgramas = false;

  late int pageEmisiones = 0;
  int totalPagesEmisiones = 0;
  bool isLoadingEmisiones = false;

  final ScrollController _scrollControllerSeries = ScrollController();
  final ScrollController _scrollControllerEpisodios = ScrollController();
  final ScrollController _scrollControllerProgramas = ScrollController();
  final ScrollController _scrollControllerEmisiones = ScrollController();

  final blocRadioSearch = RadioSearchBloc();
  final blocRadioProgramasSearch = RadioSearchProgramasBloc();
  final blocPodcastSeriesSearch = PodcastSearchSeriesBloc();
  final blocPodcastSearch = PodcastSearchBloc();

  List<Widget> cardListSeries = [];
  List<Widget> cardListEpisodios = [];
  List<Widget> cardListProgramas = [];
  List<Widget> cardListEmisiones = [];

  bool enableSeriesSearch = true;
  bool enableEpisodiosSearch = true;
  bool enableProgramasSearch = true;
  bool enableEmisionesSearch = true;


  @override
  void initState() {

    tabIndex = widget.tabIndex;
    query = widget.query;

    _tabController = TabController(length: 4, vsync: this);
    _tabController.animateTo(tabIndex);


    if(widget.sede != null){
      _sede = widget.sede;
    }else{
      _sede = 0;
    }

    if(widget.canal != null){
      _canal = widget.canal;
    }else{
      _canal = "TODOS";
    }

    if(widget.area != null){
      _area = widget.area;
    }else{
      _area = "TODOS";
    }


    if(_canal != null ){

      //Si en los filtros viene canal Podcast,
      // solo habilita busqueda de series
      // y episodios
      if(_canal == "POD"){
        enableSeriesSearch = true;
        enableEpisodiosSearch = true;
        enableProgramasSearch = false;
        enableEmisionesSearch = false;
      }

    }

    initializeScrollListener();
    initializeLoadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Resultados de busqueda",
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
                  decorationColor: const Color(0xFFFCDC4D),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                query,
                style: const TextStyle(
                  color: Color(0xff121C4A),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decorationColor: Color(0xFFFCDC4D),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Text(
                getFilterString(),
                style: const TextStyle(
                  color: Color(0xff121C4A),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  decorationColor: Color(0xFFFCDC4D),
                ),
              ),
            ),
            TabBar(
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).appBarTheme.foregroundColor,
              tabs: [
                Tab(
                  child: Text("Programas",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      )
                  ),
                ),
                Tab(
                  child: Text("Emisiones",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      )
                  ),
                ),
                Tab(
                  child: Text("Series",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),
                  ),
                ),
                Tab(
                  child: Text("Episodios",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),

                  ),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children:  [
                  drawResultList(blocRadioProgramasSearch.subject.stream, isLoadingProgramas, "PROGRAMAS"),
                  drawResultList(blocRadioSearch.subject.stream, isLoadingEmisiones, "EMISIONES"),
                  drawResultList(blocPodcastSeriesSearch.subject.stream, isLoadingSeries, "SERIES"),
                  drawResultList(blocPodcastSearch.subject.stream, isLoadingEpisodios, "EPISODIOS")

                ],
              ),
            ),
          ],
        ),
      );

  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollControllerSeries.dispose();
    _scrollControllerProgramas.dispose();
    _scrollControllerEmisiones.dispose();
    _scrollControllerEpisodios.dispose();
    blocRadioProgramasSearch.dispose();
    blocRadioSearch.dispose();
    blocPodcastSearch.dispose();
    blocPodcastSeriesSearch.dispose();
    super.dispose();
  }

  void initializeLoadData(){
      if(enableEmisionesSearch) {
        blocRadioSearch.fetchSearch(
            query,
            pageEmisiones,
            _sede,
            _canal,
            _area,
            "EMISIONES");
      }

      if(enableProgramasSearch) {
        blocRadioProgramasSearch.fetchSearch(
            query,
            pageProgramas,
            _sede,
            _canal,
            _area,
            "PROGRAMAS");
      }

      if(enableSeriesSearch) {
        blocPodcastSeriesSearch.fetchSearch(query, pageSeries, "SERIES");
      }

      if(enableEpisodiosSearch) {
        blocPodcastSearch.fetchSearch(query, pageEpisodios, "EPISODIOS");
      }
  }

  void initializeScrollListener() {
    if (enableSeriesSearch) {
      _scrollControllerSeries.addListener(() {
        if (_scrollControllerSeries.position.maxScrollExtent ==
            _scrollControllerSeries.offset) {
          if (pageSeries < totalPagesSeries) {
            pageSeries++;
            setState(() {
              isLoadingSeries = true;
            });
            Future.delayed(Duration(milliseconds: 1000), () {
              setState(() {
                isLoadingSeries = false;
              });
            });

            blocPodcastSeriesSearch.fetchSearch(query, pageSeries, "SERIES");
          }
        }
      });
    }
    if (enableEpisodiosSearch) {
      _scrollControllerEpisodios.addListener(() {
        if (_scrollControllerEpisodios.position.maxScrollExtent ==
            _scrollControllerEpisodios.offset) {
          if (pageEpisodios < totalPagesEpisodios) {
            pageEpisodios++;
            setState(() {
              isLoadingEpisodios = true;
            });
            Future.delayed(Duration(milliseconds: 1000), () {
              setState(() {
                isLoadingEpisodios = false;
              });
            });

            blocPodcastSearch.fetchSearch(query, pageEpisodios, "EPISODIOS");
          }
        }
      });
    }
    if (enableProgramasSearch){
      _scrollControllerProgramas.addListener(() {
        if (_scrollControllerProgramas.position.maxScrollExtent ==
            _scrollControllerProgramas.offset) {
          if (pageProgramas < totalPagesProgramas) {
            pageProgramas++;
            setState(() {
              isLoadingProgramas = true;
            });
            Future.delayed(Duration(milliseconds: 1000), () {
              setState(() {
                isLoadingProgramas = false;
              });
            });

            blocRadioProgramasSearch.fetchSearch(
                query,
                pageProgramas,
                0, //Buca en todas las sedes
                "TODOS",
                "TODOS",
                "PROGRAMAS");
          }
        }
      });
    }
    if(enableEmisionesSearch) {
      _scrollControllerEmisiones.addListener(() {
        if (_scrollControllerEmisiones.position.maxScrollExtent ==
            _scrollControllerEmisiones.offset) {
          if (pageEmisiones < totalPagesEmisiones) {
            pageEmisiones++;
            setState(() {
              isLoadingEmisiones = true;
            });
            Future.delayed(Duration(milliseconds: 1000), () {
              setState(() {
                isLoadingEmisiones = false;
              });
            });

            blocRadioSearch.fetchSearch(
                query,
                pageEmisiones,
                0, //Buca en todas las sedes
                "TODOS",
                "TODOS",
                "EMISIONES");
          }
        }
      });
    }
  }


  Widget drawResultList(blocStream, bool isLoading, String tipo){
    return StreamBuilder(

        stream: blocStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          Widget child;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SpinKitFadingCircle(
                  color: Color(0xffb6b3c5),
                  size: 50.0,
                ));
          } else if (snapshot.hasData) {
            child = drawContentList(snapshot, isLoading, tipo);
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
        });
  }

  Widget drawContentList(AsyncSnapshot<dynamic> snapshot, bool isLoading, String tipo) {

    InfoModel infoModel;
    infoModel = snapshot.data!["info"];

    if(tipo == "SERIES"){ totalPagesSeries = infoModel.pages;}
    if(tipo == "EPISODIOS"){ totalPagesEpisodios = infoModel.pages;}
    if(tipo == "PROGRAMAS"){ totalPagesProgramas = infoModel.pages;}
    if(tipo == "EMISIONES"){ totalPagesEmisiones = infoModel.pages;}

    return Column(
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
          Expanded(child: buildVerticalList(snapshot, tipo)),
          if (isLoading)
            const Center(
                child: SpinKitFadingCircle(
                  color: Color(0xffb6b3c5),
                  size: 50.0,
                ))
        ]
    );
  }

  Widget drawError(error) {
    return Container(
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.error_outline,
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

  Widget buildVerticalList(AsyncSnapshot<dynamic> snapshot, String tipo) {
    var list = snapshot.data!["result"];
    updateListToDraw(list, tipo);
    List<Widget> cardList=[];
    ScrollController scrollController = _scrollControllerSeries;
    if(tipo == "SERIES"){
      scrollController = _scrollControllerSeries;
      cardList = cardListSeries;
    }else if(tipo == "EPISODIOS"){
      scrollController = _scrollControllerEpisodios;
      cardList = cardListEpisodios;
    }else if(tipo == "PROGRAMAS"){
      scrollController = _scrollControllerProgramas;
      cardList = cardListProgramas;
    }else if(tipo == "EMISIONES"){
      scrollController = _scrollControllerEmisiones;
      cardList = cardListEmisiones;
    }

    return ListView(
        shrinkWrap: true, controller: scrollController, children: cardList);
  }

  Widget buildCardForVerticalList(element, String tipo) {
    var width = MediaQuery.of(context).size.width;
    DateTime now;
    try {
      now = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(element.date);
    } catch (noDateException) {
      now = DateTime.now();
    }

    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(now);

    var messageStr = "";
    var redirectTo = "";
    if(tipo=="SERIES") {
      messageStr = "PODCAST";
      redirectTo = "/detail";
    }else if(tipo=="EPISODIOS"){
      messageStr = "PODCAST";
      redirectTo = "/item";
    }
    else if(tipo=="PROGRAMAS"){
      messageStr = "RADIO";
      redirectTo = "/detail";
    }
    else if(tipo=="EMISIONES"){
      messageStr = "RADIO";
      redirectTo = "/item";
    }

    return InkWell(
        onTap: () {
            Navigator.pushNamed(context, redirectTo,
                arguments: ScreenArguments(
                "SITE",
                  messageStr,
                  element.uid,
                  element: element));
        },
        child: Container(
            padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: width * 0.25,
                  height: width * 0.25,
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
                    child: CachedNetworkImage(fit: BoxFit.cover,
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
                        drawCategoryTitle(element),
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
                          child: drawDuration(formatted, element),
                        )
                      ]))
            ])));
  }

  Text drawDuration(String formatted, element) {
    try {
      return Text(
        "$formatted ${(element != null && element.duration != null && element.duration != "") ? formatDurationString(element.duration) : ''}",
        style: const TextStyle(
            fontSize: 10, color: Color(0xff666666)),
      );

    } catch (e) {

    }
    return Text('');
  }

  Container drawCategoryTitle(element) {
    try {
      if (element.categoryTitle != null && element.categoryTitle != "")
        return Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          margin: const EdgeInsets.only(left: 20, bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.foregroundColor,
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
            element.categoryTitle,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        );
    } catch (e) {}
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.foregroundColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color(0xff121C4A).withOpacity(0.3),
        //     spreadRadius: 3,
        //     blurRadius: 10,
        //     offset: const Offset(5, 5), // changes position of shadow
        //   ),
        // ],
      ),
      child: Text(
        '',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
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

  updateListToDraw(List list, String tipo){

    list?.forEach(
            (element) => {
              if(tipo == "SERIES"){
                cardListSeries.add(buildCardForVerticalList(element, tipo))
              } else if(tipo == "EPISODIOS"){
                cardListEpisodios.add(buildCardForVerticalList(element, tipo))
              }
              else if(tipo == "PROGRAMAS"){
                cardListProgramas.add(buildCardForVerticalList(element, tipo))
              }
              else if(tipo == "EMISIONES"){
                cardListEmisiones.add(buildCardForVerticalList(element, tipo))
              }

            });

  }

  String getFilterString(){

    //"Sede Medellín | Radio Web | Actualidad"
    String str = "";
    if(_sede != null){
      str = str + "Sede" + _sede.toString();
    }

    if(_canal != null){
      str = str + " | " + _canal.toString();
    }

    if(_area != null){
      str = str + " | " + _area.toString();
    }

    return str;

  }

}

