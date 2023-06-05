import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:share_plus/share_plus.dart';

import '../../business_logic/firebase/firebaseLogic.dart';
import 'favorito_btn.dart';

class BottomNavigationBarRadio extends StatefulWidget {
  const BottomNavigationBarRadio({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarRadio> createState() =>
      BottomNavigationBarRadioState();
}

class BottomNavigationBarRadioState extends State<BottomNavigationBarRadio>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _expanded = false;
  late int uid = 5;
  var audioUrl =
      "http://podcastradio.unal.edu.co/fileadmin/Radio/Audio-imagenes/2022/11/RGU_E68-Politicas_urbana_y_social-1.mp3";
  var imagenUrl =
      "http://podcastradio.unal.edu.co/fileadmin/Radio/Audio-imagenes/2022/11/RGU_E68-Politicas_urbana_y_social-1.png";
  var url = "";
  var textParent = "Análisis Unal";
  var title =
      "E90: Analizamos el nombramiento de Rishi Sunak como nuevo primer ministro de Reino Unido y más en nuestra selección de noticias. E90: Analizamos el nombramiento de Rishi Sunak como nuevo primer ministro de Reino Unido y más en nuestra selección de noticias. E90: Analizamos el nombramiento de Rishi Sunak como nuevo primer ministro de Reino Unido y más en nuestra selección de noticias.E90: Analizamos el nombramiento de Rishi Sunak como nuevo primer ministro de Reino Unido y más en nuestra selección de noticias.E90: Analizamos el nombramiento de Rishi Sunak como nuevo primer ministro de Reino Unido y más en nuestra selección de noticias.";
  var textContent =
      "• Noticia 1: En China, durante el Congreso del Partido Comunista, el presidente Xi Jinping obtuvo un histórico tercer mandato consecutivo.\r\nEspecialista invitado: Javier Sánchez Segura, profesor de Ciencia Política en la Universidad de Antioquia y experto en temas de Asia.\r\n\r\n• Noticia 2: Reino Unido ya tiene sucesor de Liz Truss. Se trata de Rishi Sunak, el nuevo primer ministro quien fue aprobado por el Rey Carlos III.\r\nEspecialista invitada: Natalia Encalada, máster en Relaciones Internacionales y coordinadora académica de la Escuela de Relaciones Internacionales en la Universidad Internacional de Ecuador.\r\n\r\n• Noticia 3: Después de un año del golpe de estado en Sudán, la incertidumbre continúa en el país africano.\r\nEspecialista invitado: Beatriz Escobar, Licenciada en Relaciones Internacionales, doctora en Estudios de Asia y África y profesora de la Facultad de Ciencias Políticas y Sociales de la UNAM.\r\n\r\n• Noticia 4: El presidente de Rusia, Vladimir Putin, supervisó unos ejercicios militares de las fuerzas de disuasión nuclear en los que se ensayó un ataque “masivo” que, según el Gobierno, se produciría como respuesta a una hipotética agresión externa.\r\nEspecialista invitado: Javier Gil, licenciado en Ciencias Políticas y de la Administración. Doctor en Seguridad y Defensa Internacional. Profesor de la Universidad Pontificia Comillas.\r\n\r\n• Noticia 5: En un nuevo intento de integrar a los países de la región, se llevó a cabo en Bogotá la Cumbre de Integración Latinoamericana y Caribeña.\r\nEspecialista invitado: Giacomo Finzi, licenciado en Relaciones Internacionales, magister en Ciencias Internacionales y Diplomáticas y Doctorando en estudios políticos y relaciones internacionales.\r\n\r\nLocución: Ángela Sánchez.\r\nProducción sonora: Edgar Guasca y Alejandra Carvajal.\r\nInvestigación periodística: Eliana Escandón.\r\nWeb Máster: Carlos Fabián Rodríguez Navarrete.";
  var date =
      DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse("2022-10-29T07:00:00+00:00");
  var type = "";
  String durationContent = "";
  var canExpand = false;
  var hasDuration = false;

  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  bool isLoading = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool showVolumenSlider = false;
  bool showSpeedList = false;
  double currentVolumen = 1.0;

  String currentSpeedText = "1.0";
  List<String> listSpeedText = ['0.5', '1.0', '1.5', '2.0'];


  var speedListItems = const [
    DropdownMenuItem<double>(value: 0.5, child: Text("0.5x")),
    DropdownMenuItem<double>(value: 1.0, child: Text("1.0x")),
    DropdownMenuItem<double>(value: 1.5, child: Text("1.5x")),
    DropdownMenuItem<double>(value: 2.0, child: Text("2.0x"))
  ];
  var dropDownValue = 1.0;
  var speedListItemsBuilder = <Widget>[];

  var _maxHeight = 0.0;
  var _minHeight = 0.0;

  late FavoritoBtn? myFavoritoBtn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    //Estación de bogotá
    audioUrl = "http://streaming.unradio.unal.edu.co:8010/;stream.mp3";
    //audioUrl = "http://podcastradio.unal.edu.co/fileadmin/Radio/Audio-imagenes/2022/11/RGU_E68-Politicas_urbana_y_social-1.mp3";
    imagenUrl = "";
    url = "http://radio.unal.edu.co/bogota-985";
    textParent = "";
    title = "Bogotá 98.5 fm";
    textContent = "";
    date =
        DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse("2022-10-29T07:00:00+00:00");
    type = "";
    durationContent = "";
    canExpand = false;
    hasDuration = false;
    speedListItemsBuilder = const [
      Text("0.5x", style: TextStyle(color: Colors.white)),
      Text("1.0x", style: TextStyle(color: Colors.white)),
      Text("1.5x", style: TextStyle(color: Colors.white)),
      Text("2.0x", style: TextStyle(color: Colors.white))
    ];

    audioPlayer = AudioPlayer();
    audioPlayer.setVolume(currentVolumen);
    audioPlayer.setPlaybackRate(dropDownValue);

    myFavoritoBtn = FavoritoBtn(uid: uid, message: type, isPrimaryColor: false);

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';

    audioPlayer.onPlayerStateChanged.listen((state) {
      print(">> cambia el estado");
      print(state);

      if (state == PlayerState.PLAYING) {
        print(">> playing");
        setState(() {
          isPlaying = true;
        });
      }

      if (state == PlayerState.PAUSED) {
        print(">> Completo y listo para ser escuchado");
        setState(() {
          isPlaying = false;
        });
      }

      if (state == PlayerState.COMPLETED) {
        print(">> Completo y listo para ser escuchado");
        audioPlayer.play(audioUrl);
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      if (hasDuration) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      if (hasDuration) {
        setState(() {
          position = newPosition;
        });
      }
      if (newPosition.inMicroseconds > 0) {
        setState(() {
          isLoading = false;
        });
      }
    });

    //firebaseLogic = FirebaseLogic();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  String formatDateString(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formatted = formatter.format(date);

    return formatted;
  }

  String formatDurationString(String duration) {
    String formatted = "";
    if (duration != null) {
      if (duration.substring(0, 2) == "00") {
        formatted = "| " + duration.substring(3);
      } else {
        formatted = "| " + duration;
      }
    }

    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _maxHeight = size.height * 0.88;
    _minHeight = 110;

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          final value = _controller.value;

          return Stack(
            children: [
              Container(
                  height: lerpDouble(_minHeight, _maxHeight, value),
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      child: _expanded
                          ? audioPlayerExpanded()
                          : audioPlayerMini()))
            ],
          );
        });
  }

  String formatTimeString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget drawAudioPlayer() {
    return Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      color: Colors.white,
                      iconSize: 40,
                      icon: const Icon(Icons.volume_down),
                      onPressed: () async {
                        setState(() {
                          showVolumenSlider = !showVolumenSlider;
                        });
                      },
                    )
                  ],
                ),
                IconButton(
                  color: Colors.white,
                  iconSize: 50,
                  icon: const Icon(Icons.arrow_left),
                  onPressed: () async {
                    if (position.inSeconds > 10) {
                      audioPlayer.seek(position - const Duration(seconds: 10));
                    }
                  },
                ),
                IconButton(
                  color: Colors.white,
                  iconSize: 80,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.play(audioUrl);
                    }
                  },
                ),
                IconButton(
                    color: Colors.white,
                    iconSize: 50,
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () async {
                      if (position.inSeconds < duration.inSeconds - 10) {
                        audioPlayer
                            .seek(position + const Duration(seconds: 10));
                      }
                    }),
                Container(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          showSpeedList = !showSpeedList;
                        });
                      },
                      child: Text("${currentSpeedText}x",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          )
                      ),
                    )


                )
              ],
            ),
            Row(children: [
              Expanded(
                  child: Slider(
                      activeColor: const Color(0xffFCDC4D),
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        audioPlayer.seek(Duration(seconds: value.toInt()));
                      })),
              Text(
                  "${formatTimeString(position)}/${formatTimeString(duration)}",
                  style: const TextStyle(
                      color: Color(0xffFCDC4D), fontStyle: FontStyle.italic))
            ]),
          ],
        ));
  }

  Widget audioPlayerExpanded() {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/FONDO_AZUL_REPRODUCTOR.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Color(0xff121C4A)),
        child: Stack(
          children: [
            Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                      _controller.reverse();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(
                            right: 20, top: 20, bottom: 10),
                        child: SvgPicture.asset(
                            'assets/icons/icono_flechita_down.svg',
                            width: MediaQuery.of(context).size.width * 0.05)))
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  myFavoritoBtn!,
                  IconButton(
                    color: const Color(0xffFCDC4D),
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      Share.share("Escucha Radio UNAL -  ${url}",
                          subject: "Radio UNAL - ${title}");
                    },
                  )
                ],
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    Center(
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 60, right: 60),
                          child: getImageExpand()),
                    ),
                    if (textParent != "")
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            color: const Color(0xffFCDC4D),
                            child: Text(
                              textParent,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                    if (title != "")
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              top: 10, left: 30, right: 30),
                          child: Text(title,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))),
                    if (date != null)
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              top: 10, left: 30, right: 30),
                          child: Text(
                              "${formatDateString(date)} ${formatDurationString(durationContent)}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white))),
                    if (type != "")
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              top: 10, left: 30, right: 30),
                          child: Text(
                              type[0].toUpperCase() +
                                  type.substring(1, type.length).toLowerCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic)))
                  ])),
              drawAudioPlayer(),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: SvgPicture.asset('assets/images/firma.svg',
                              width: 180))))
            ]),
            if (showVolumenSlider)
              Positioned(
                  bottom: 200,
                  left: 20,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                        inactiveColor: Colors.white70,
                        activeColor: const Color(0xffFCDC4D),
                        min: 0,
                        max: 1.0,
                        value: currentVolumen,
                        onChanged: (value) async {
                          setState(() {
                            currentVolumen = value;
                          });
                          audioPlayer.setVolume(currentVolumen);
                        }),
                  )),
            if (showSpeedList)
              Positioned(
                  bottom: 200,
                  right: 25,
                  child:
                    drawListSpeed()
              )

          ],
        ));
  }

  Widget audioPlayerMini() {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 1),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Color(0xff121C4A)),
        child: Column(children: [
          Row(children: [
            getImageMini(),
            Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 20),
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (title != "")
                            Container(
                                //width: double.infinity,

                                //width: 220,
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                    (title.length > 35)
                                        ? "${title.substring(0, 35)}..."
                                        : title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
                          Container(
                              //padding: EdgeInsets.only(left: 40),
                              child: (canExpand)
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _expanded = !_expanded;
                                            });
                                            _controller.forward();
                                          },
                                          child: SvgPicture.asset(
                                              'assets/icons/icono_flechita_up.svg',
                                              width: 20)))
                                  : null)
                        ])),
                Row(children: [
                  IconButton(
                    color: const Color(0xffFCDC4D),
                    iconSize: 40,
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                      } else {
                        await audioPlayer.play(audioUrl);
                      }
                    },
                  ),
                  Slider(
                      activeColor: const Color(0xffFCDC4D),
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        audioPlayer.seek(Duration(seconds: value.toInt()));
                      }),
                  Text(formatTimeString(position),
                      style: const TextStyle(
                          color: Color(0xffFCDC4D),
                          fontStyle: FontStyle.italic))
                ])
              ],
            )
          ]),
          Container(
            child: SvgPicture.asset('assets/images/firma.svg', width: 180),
          )
        ]));
  }

  playMusic(
      uidParam,
      audioUrlParam,
      imagenUrlParam,
      textParentParam,
      titleParam,
      textContentParam,
      dateParam,
      durationParam,
      typeParam,
      urlParam,
      bool isFrecuencia,
      FavoritoBtn? favoritoBtn) {
    if (dateParam == "") {
      setState(() {
        date = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ")
            .parse("2022-10-29T07:00:00+00:00");
      });
    } else {
      setState(() {
        date = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(dateParam);
      });
    }

    setState(() {
      uid = uidParam;
      imagenUrl = imagenUrlParam;
      textParent = textParentParam;
      title = titleParam.replaceAll("\n", " ");
      textContent = textContentParam;
      type = typeParam;
      url = urlParam;
      durationContent = durationParam;
    });

    //En el caso que sean alguna de las cuantro frecuencias
    if (isFrecuencia) {
      setState(() {
        canExpand = false;
        hasDuration = false;
      });
    } else {
      print(">>>> BNT");
      print(favoritoBtn);

      setState(() {
        canExpand = true;
        hasDuration = true;
        //myFavoritoBtn = favoritoBtn;
      });
    }

    myFavoritoBtn = FavoritoBtn(uid: uid, message: type, isPrimaryColor: false);

    setState(() {
      audioUrl = audioUrlParam;
    });
    print(audioUrlParam);
    updateAudioUrl(audioUrlParam);
  }

  updateAudioUrl(url) async {
    //await audioPlayer.pause();
    setState(() {
      isLoading = true;
    });

    audioPlayer.setUrl(url);
    audioPlayer.play(url);
  }

  Widget getImageMini() {
    Widget widget;
    Widget widgetImg;

    if (imagenUrl != "") {
      widgetImg = CachedNetworkImage(
        imageUrl: imagenUrl,
        placeholder: (context, url) => const Center(
            child: SpinKitFadingCircle(
          color: Color(0xffb6b3c5),
          size: 10.0,
        )),
        errorWidget: (context, url, error) => Container(
            color: Theme.of(context).primaryColor,
            child: Image.asset("assets/images/default.png")),
      );
    } else {
      widgetImg = Image.asset('assets/images/default.png');
    }

    widget = Container(
        padding: const EdgeInsets.only(left: 10),
        width: MediaQuery.of(context).size.width * 0.2,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(children: [
              widgetImg,
              if (isLoading)
                const Center(
                    child: SpinKitFadingCircle(
                  color: Color(0xffb6b3c5),
                  //size: 50.0,
                ))
            ])));

    return widget;
  }

  Widget getImageExpand() {
    Widget widget;
    Widget widgetImg;

    if (imagenUrl != "") {
      widgetImg = ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: CachedNetworkImage(
            imageUrl: imagenUrl,
            placeholder: (context, url) => const Center(
                child: SpinKitFadingCircle(
              color: Color(0xffb6b3c5),
              size: 50.0,
            )),
            errorWidget: (context, url, error) => Container(
                color: Theme.of(context).primaryColor,
                child: Image.asset("assets/images/default.png")),
          ));
    } else {
      widgetImg = ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image.asset('assets/images/default.png'));
    }

    return widgetImg;
  }

  Widget drawListSpeed(){

    List<Widget> list = [];
    for (var element in listSpeedText) {
      list.add(

        Container(
          padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white, // Color del borde
                width: 0, // Ancho del borde
              ),
            ),
          child:
              InkWell(
                  onTap: (){
                    setState(() {
                      currentSpeedText = element;
                    });
                    audioPlayer.setPlaybackRate(double.parse(currentSpeedText));
                    setState(() {
                      showSpeedList = false;
                    });

                  },
                  child:

              Text(
                "${element}x",
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor
                ),
              )
              )
        )
      );
    }

    return Column(
      children: list
    );
  }
}
