import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  int? sede;
  String? canal;
  String? area;
  String? filterString;

  MultiTabResult(
      {Key? key,
      required this.tabIndex,
      required this.query,
      required this.page,
      required this.sede,
      required this.canal,
      required this.area,
      required this.filterString})
      : super(key: key);

  @override
  State<MultiTabResult> createState() => _MultiTabResultState();
}

class _MultiTabResultState extends State<MultiTabResult>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;
  String query = "";
  int? _sede = 0;
  String? _canal = "TODOS";
  String? _area = "TODOS";
  String? filterString = "";

  late int pageSeries = 1;
  int totalPagesSeries = 0;
  bool isLoadingSeries = false;
  List elementListSeries = [];

  late int pageEpisodios = 1;
  int totalPagesEpisodios = 0;
  bool isLoadingEpisodios = false;
  List elementListEpisodios = [];

  late int pageProgramas = 1;
  int totalPagesProgramas = 0;
  bool isLoadingProgramas = false;
  List elementListProgramas = [];

  late int pageEmisiones = 1;
  int totalPagesEmisiones = 0;
  bool isLoadingEmisiones = false;
  List elementListEmisiones = [];

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
  bool isDarkMode = false;

Future<AdaptiveThemeMode?> themeMethod() async {
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
return savedThemeMode;
}

  @override
  void initState() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    tabIndex = widget.tabIndex;
    query = widget.query;

    _tabController = TabController(length: 4, vsync: this);
    _tabController.animateTo(tabIndex);

    if (widget.sede != null) {
      _sede = widget.sede;
    } else {
      _sede = 0;
    }

    if (widget.canal != null) {
      _canal = widget.canal;
    } else {
      _canal = "TODOS";
    }

    if (widget.area != null) {
      _area = widget.area;
    } else {
      _area = "TODOS";
    }

    if (widget.filterString != null) {
      filterString = widget.filterString;
    } else {
      filterString = "";
    }

    if (_canal != null) {
      //Si en los filtros viene canal Podcast,
      // solo habilita busqueda de series
      // y episodios
      if (_canal == "POD") {
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
                    themeMethod().then((value) {
          setState(() {
            
     isDarkMode=value==AdaptiveThemeMode.dark;
          });
    });
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
                      color:isDarkMode?Color(0xFFFFFFFF):Color(0xFF121C4A),
                      offset: const Offset(0, -5))
                ],
                color: Colors.transparent,
                decorationThickness: 2,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decorationColor: Color(isDarkMode ? 0x00121C4A : 0xFFFCDC4D),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              query,
              style: TextStyle(
                color: isDarkMode ? Color(0xFFFCDC4D) : Color(0xff121C4A),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                decorationColor: isDarkMode ? Color(0xff121C4A) : Color(0xFFFCDC4D),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              filterString ?? "",
              style: TextStyle(
                color:isDarkMode ? Color( 0xFFFFFFFF) :  Color(0xff121C4A),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                decorationColor: Color(isDarkMode ? 0xff121C4A : 0xFFFCDC4D),
              ),
            ),
          ),
          TabBar(
            unselectedLabelColor: Colors.transparent,
            labelColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            labelStyle: TextStyle(
              shadows: [
                Shadow(
                    color: Theme.of(context).primaryColor,
                    offset: const Offset(0, -5))
              ],
              color: Colors.transparent,
              decorationThickness: 2,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              decorationColor: const Color(0xFFFCDC4D),
              decoration: TextDecoration.underline,
            ),
            unselectedLabelStyle: TextStyle(shadows: [
              Shadow(
                  color: Theme.of(context).primaryColor,
                  offset: const Offset(0, -5))
            ], color: Colors.transparent, fontSize: 13),
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(child: Text("Programas")),
              Tab(child: Text("Emisiones")),
              Tab(child: Text("Series")),
              Tab(child: Text("Episodios"))
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                (enableProgramasSearch)
                    ? drawResultList(blocRadioProgramasSearch.subject.stream,
                        isLoadingProgramas, "PROGRAMAS")
                    : getZeroResults(),
                (enableEmisionesSearch)
                    ? drawResultList(blocRadioSearch.subject.stream,
                        isLoadingEmisiones, "EMISIONES")
                    : getZeroResults(),
                (enableSeriesSearch)
                    ? drawResultList(blocPodcastSeriesSearch.subject.stream,
                        isLoadingSeries, "SERIES")
                    : getZeroResults(),
                (enableEpisodiosSearch)
                    ? drawResultList(blocPodcastSearch.subject.stream,
                        isLoadingEpisodios, "EPISODIOS")
                    : getZeroResults()
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

  void initializeLoadData() {
    if (enableEmisionesSearch) {
      blocRadioSearch.fetchSearch(query, pageEmisiones, _sede ?? 0,
          _canal ?? "TODOS", _area ?? "TODOS", "EMISIONES");
    }

    if (enableProgramasSearch) {
      blocRadioProgramasSearch.fetchSearch(query, pageProgramas, _sede ?? 0,
          _canal ?? "TODOS", _area ?? "TODOS", "PROGRAMAS");
    }

    if (enableSeriesSearch) {
      blocPodcastSeriesSearch.fetchSearch(query, pageSeries, "SERIES");
    }

    if (enableEpisodiosSearch) {
      blocPodcastSearch.fetchSearch(query, pageEpisodios, "EPISODIOS");
    }
  }

  void initializeScrollListener() {
    if (enableSeriesSearch) {
      _scrollControllerSeries.addListener(() {
        if (_scrollControllerSeries.position.maxScrollExtent ==
            _scrollControllerSeries.offset) {
          if (pageSeries < totalPagesSeries) {
            setState(() {
              pageSeries+=1;
              isLoadingSeries = true;
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
            setState(() {
              pageEpisodios+=1;
              isLoadingEpisodios = true;
            });

            blocPodcastSearch.fetchSearch(query, pageEpisodios, "EPISODIOS");
          }
        }
      });
    }
    if (enableProgramasSearch) {
      _scrollControllerProgramas.addListener(() {
        if (_scrollControllerProgramas.position.maxScrollExtent ==
            _scrollControllerProgramas.offset) {
          if (pageProgramas < totalPagesProgramas) {
            setState(() {
              pageProgramas+=1;
              isLoadingProgramas = true;
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
    if (enableEmisionesSearch) {
      _scrollControllerEmisiones.addListener(() {
        if (_scrollControllerEmisiones.position.maxScrollExtent ==
            _scrollControllerEmisiones.offset) {
          if (pageEmisiones < totalPagesEmisiones) {
            setState(() {
              pageEmisiones += 1;
              isLoadingEmisiones = true;
            });

            blocRadioSearch.fetchSearch(
                query,
                pageEmisiones,
                0, //Busca en todas las sedes
                "TODOS",
                "TODOS",
                "EMISIONES");
          }
        }
      });
    }
  }

  Widget drawResultList(blocStream, bool isLoading, String tipo) {
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

  Widget drawContentList(
      AsyncSnapshot<dynamic> snapshot, bool isLoading, String tipo) {
    InfoModel infoModel;
    infoModel = snapshot.data!["info"];

    if (tipo == "SERIES") {
      totalPagesSeries = infoModel.pages;
    }
    if (tipo == "EPISODIOS") {
      totalPagesEpisodios = infoModel.pages;
    }
    if (tipo == "PROGRAMAS") {
      totalPagesProgramas = infoModel.pages;
    }
    if (tipo == "EMISIONES") {
      totalPagesEmisiones = infoModel.pages;
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "${infoModel.count} resultados",
              style: TextStyle(
                color:isDarkMode ? Color( 0xFFFFFFFF) :  Color(0xff121C4A),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                decorationColor: Color(isDarkMode ? 0xff121C4A : 0xFFFCDC4D),
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
        ]);
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
    List<Widget> cardList = [];
    ScrollController scrollController = _scrollControllerSeries;
    if (tipo == "SERIES") {
      scrollController = _scrollControllerSeries;
      cardList = cardListSeries;
    } else if (tipo == "EPISODIOS") {
      scrollController = _scrollControllerEpisodios;
      cardList = cardListEpisodios;
    } else if (tipo == "PROGRAMAS") {
      scrollController = _scrollControllerProgramas;
      cardList = cardListProgramas;
    } else if (tipo == "EMISIONES") {
      scrollController = _scrollControllerEmisiones;
      cardList = cardListEmisiones;
    }

    return ListView(padding: EdgeInsets.zero,
        shrinkWrap: true, controller: scrollController, children: cardList);
  }

  Widget buildCardForVerticalList(element, String tipo) {
    var site = "";
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
    if (tipo == "SERIES") {
      messageStr = "PODCAST";
      redirectTo = "/detail";
      site = "Podcast";
    } else if (tipo == "EPISODIOS") {
      messageStr = "PODCAST";
      redirectTo = "/item";
      site = "Podcast";
    } else if (tipo == "PROGRAMAS") {
      messageStr = "RADIO";
      redirectTo = "/detail";
      site = "Radio";
    } else if (tipo == "EMISIONES") {
      messageStr = "RADIO";
      redirectTo = "/item";
      site = "Radio";
    }

    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, redirectTo,
              arguments: ScreenArguments("SITE", messageStr, element.uid,
                  element: element,
                  from: "BROWSER_RESULT_PAGE"
              ));
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
                        color: Color( 0xff121C4A)
                            .withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
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
                    Container(color: Color(0xFFFCDC4D),
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        element.title,
                        maxLines: 5,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF121C4A)
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        site,
                        style: TextStyle(
                            fontSize: 11,
                            color: isDarkMode?Color(0xFFFFFFFF):Color(0xFF121C4A),
                            fontStyle: FontStyle.italic),
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
        style: const TextStyle(fontSize: 10, color: Color(0xff666666)),
      );
    } catch (e) {}
    return Text('');
  }

  Container drawCategoryTitle(element) {
    try {
      if (element.categoryTitle != null && element.categoryTitle != "") {
        return Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          margin: const EdgeInsets.only(left: 20, bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.foregroundColor,
            boxShadow: [
              BoxShadow(
                color:  Color(0xff121C4A)
                    .withOpacity(0.3),
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
      }
    } catch (e) {}
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.foregroundColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color(isDarkMode?:0xFFFCDC4D:0xff121C4A).withOpacity(0.3),
        //     spreadRadius: 3,
        //     blurRadius: 10,
        //     offset: const Offset(5, 5), // changes position of shadow
        //   ),
        // ],
      ),
      child: const Text(
        '',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
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

  updateListToDraw(List list, String tipo) {
    list?.forEach((element) => {
          if (tipo == "SERIES")
            {

              if (!elementListSeries.contains(element))
                {
                  setFalseLoadig().then((value) => {
                    setState(() {
                      isLoadingSeries = false;
                    })
                  }),
                  cardListSeries.add(buildCardForVerticalList(element, tipo)),
                  elementListSeries.add(element)
                }
            }
          else if (tipo == "EPISODIOS")
            {

              if (!elementListEpisodios.contains(element))
                {
                  setFalseLoadig().then((value) => {
                    setState(() {
                      isLoadingEpisodios = false;
                    })
                  }),
                  cardListEpisodios
                      .add(buildCardForVerticalList(element, tipo)),
                  elementListEpisodios.add(element)
                }
            }
          else if (tipo == "PROGRAMAS")
            {
              if (!elementListProgramas.contains(element))
                {

                  setFalseLoadig().then((value) => {
                    setState(() {
                      isLoadingProgramas = false;
                    })
                  }),

                  cardListProgramas
                      .add(buildCardForVerticalList(element, tipo)),
                  elementListProgramas.add(element)
                }
            }
          else if (tipo == "EMISIONES")
            {
              if (!elementListEmisiones.contains(element.uid))
                {
                  setFalseLoadig().then((value) => {
                        setState(() {
                          isLoadingEmisiones = false;
                        })
                      }),
                  cardListEmisiones
                      .add(buildCardForVerticalList(element, tipo)),
                  elementListEmisiones.add(element.uid)
                }
            }
        });
  }

  Future<bool> setFalseLoadig() async {
    return false;
  }

  Widget getZeroResults() {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: const Text(
        "0 resultados",
        style: TextStyle(
          color: Color(0xff121C4A),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          decorationColor: Color(0xFFFCDC4D),
        ),
      ),
    );
  }
}
