import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class BottomNavigationBarRadio extends StatefulWidget {
  const BottomNavigationBarRadio({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarRadio> createState() => _BottomNavigationBarRadioState();
}

class _BottomNavigationBarRadioState extends State<BottomNavigationBarRadio>  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _expanded = false;

  var audioUrl =
      "http://podcastradio.unal.edu.co/fileadmin/Radio/Audio-imagenes/2022/11/RGU_E68-Politicas_urbana_y_social-1.mp3";
  var imagenUrl =
      "http://podcastradio.unal.edu.co/fileadmin/Radio/Audio-imagenes/2022/11/RGU_E68-Politicas_urbana_y_social-1.png";
  var textParent = "Análisis Unal";
  var title =
      "E90: Analizamos el nombramiento de Rishi Sunak como nuevo primer ministro de Reino Unido y más en nuestra selección de noticias. E90: Analizamos el nombramiento de Rishi Sunak como nuevo primer ministro de Reino Unido y más en nuestra selección de noticias. E90: Analizamos el nombramiento de Rishi Sunak como nuevo primer ministro de Reino Unido y más en nuestra selección de noticias.E90: Analizamos el nombramiento de Rishi Sunak como nuevo primer ministro de Reino Unido y más en nuestra selección de noticias.E90: Analizamos el nombramiento de Rishi Sunak como nuevo primer ministro de Reino Unido y más en nuestra selección de noticias.";
  var textContent =
      "• Noticia 1: En China, durante el Congreso del Partido Comunista, el presidente Xi Jinping obtuvo un histórico tercer mandato consecutivo.\r\nEspecialista invitado: Javier Sánchez Segura, profesor de Ciencia Política en la Universidad de Antioquia y experto en temas de Asia.\r\n\r\n• Noticia 2: Reino Unido ya tiene sucesor de Liz Truss. Se trata de Rishi Sunak, el nuevo primer ministro quien fue aprobado por el Rey Carlos III.\r\nEspecialista invitada: Natalia Encalada, máster en Relaciones Internacionales y coordinadora académica de la Escuela de Relaciones Internacionales en la Universidad Internacional de Ecuador.\r\n\r\n• Noticia 3: Después de un año del golpe de estado en Sudán, la incertidumbre continúa en el país africano.\r\nEspecialista invitado: Beatriz Escobar, Licenciada en Relaciones Internacionales, doctora en Estudios de Asia y África y profesora de la Facultad de Ciencias Políticas y Sociales de la UNAM.\r\n\r\n• Noticia 4: El presidente de Rusia, Vladimir Putin, supervisó unos ejercicios militares de las fuerzas de disuasión nuclear en los que se ensayó un ataque “masivo” que, según el Gobierno, se produciría como respuesta a una hipotética agresión externa.\r\nEspecialista invitado: Javier Gil, licenciado en Ciencias Políticas y de la Administración. Doctor en Seguridad y Defensa Internacional. Profesor de la Universidad Pontificia Comillas.\r\n\r\n• Noticia 5: En un nuevo intento de integrar a los países de la región, se llevó a cabo en Bogotá la Cumbre de Integración Latinoamericana y Caribeña.\r\nEspecialista invitado: Giacomo Finzi, licenciado en Relaciones Internacionales, magister en Ciencias Internacionales y Diplomáticas y Doctorando en estudios políticos y relaciones internacionales.\r\n\r\nLocución: Ángela Sánchez.\r\nProducción sonora: Edgar Guasca y Alejandra Carvajal.\r\nInvestigación periodística: Eliana Escandón.\r\nWeb Máster: Carlos Fabián Rodríguez Navarrete.";
  var date =
  DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse("2022-10-29T07:00:00+00:00");
  var type = "podcast";

  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool showVolumenSlider = false;
  bool showSpeedList = true;
  double currentVolumen = 1.0;
  var speedListItems = const [
    DropdownMenuItem<double>(
        value: 0.5, child: Text("0.5x", style: TextStyle(color: Colors.white))),
    DropdownMenuItem<double>(
        value: 1.0, child: Text("1.0x", style: TextStyle(color: Colors.white))),
    DropdownMenuItem<double>(
        value: 1.5, child: Text("1.5x", style: TextStyle(color: Colors.white))),
    DropdownMenuItem<double>(
        value: 2.0, child: Text("2.0x", style: TextStyle(color: Colors.white)))
  ];
  var dropDownValue = 1.0;

  var _maxHeight = 0.0;
  var _minHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    audioPlayer = AudioPlayer();
    audioPlayer.setVolume(currentVolumen);
    audioPlayer.setPlaybackRate(dropDownValue);

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    _maxHeight = MediaQuery.of(context).size.height * 0.88;
    _minHeight = MediaQuery.of(context).size.height * 0.18;

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          var value = _controller.value;

          return
            Stack(
            children: [

              Positioned(
                  height: lerpDouble(_minHeight, _maxHeight, value),
                  width: size.width,
                  bottom: 0,
                  child: _expanded ? audioPlayerExpanded() : audioPlayerMini()
                  )

            ],
          );
        });
  }

  String formatDateString(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy | HH:mm');
    final String formatted = formatter.format(date);

    return formatted;
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
                DropdownButtonHideUnderline(
                    child: DropdownButton(
                        dropdownColor: const Color(0xff121C4A),
                        focusColor: const Color(0xffFCDC4D),
                        iconSize: 0.0,
                        items: speedListItems,
                        value: dropDownValue,
                        onChanged: (value) {
                          setState(() {
                            dropDownValue = value!;
                          });

                          audioPlayer.setPlaybackRate(dropDownValue);
                        }))
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
                        audioPlayer
                            .seek(Duration(seconds: value.toInt()));
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
    return

      Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Color(0xff121C4A)),
        child: Stack(
          children: [
            Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                  color: const Color(0xffFCDC4D),
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                    _controller.reverse();
                  },
                )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      color: const Color(0xffFCDC4D),
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        //TODO: "AGRAGAR A MIS FAVORITOS EN FIREBASE"
                        print("AGRAGAR A MIS FAVORITOS EN FIREBASE");
                      }),
                  IconButton(
                    color: const Color(0xffFCDC4D),
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      //TODO: "COMPATIR EN REDES SOCIALES"
                      print("COMPATIR EN REDES SOCIALES");
                    },
                  )
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        Center(
                          child: Container(
                              margin: const EdgeInsets.only(
                                  top: 20, bottom: 20, left: 60, right: 60),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Image.network(imagenUrl))),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 30, right: 30),
                          child: Container(
                              padding:
                              const EdgeInsets.only(left: 10, right: 10),
                              color: const Color(0xffFCDC4D),
                              child: Text(textParent)),
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 30, right: 30),
                            child: Text(title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(
                                top: 10, left: 30, right: 30),
                            child: Text(formatDateString(date),
                                style: const TextStyle(color: Colors.white))),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(
                                top: 10, left: 30, right: 30),
                            child: Text(type,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic)))
                      ]))),
              drawAudioPlayer(),
              const Center(
                child: Text("Universidad Nacional de Colombia",

                    style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Color(0xffFCDC4D)
                    )),
              )

            ]),
            if (showVolumenSlider)
              Positioned(
                  bottom: 100,
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
          ],
        ));
  }

  Widget audioPlayerMini() {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                color: Color(0xff121C4A)
            ),
        child:Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              color: const Color(0xffFCDC4D),
              icon: const Icon(Icons.keyboard_arrow_up),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
                _controller.forward();
              },
            )
          ]),
          Row(children: [
            Container(
                padding: const EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width * 0.2,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(imagenUrl))),
            Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    child: Text("${title.substring(1, 40)}...",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))),
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
                        audioPlayer
                            .seek(Duration(seconds: value.toInt()));
                      }),

                  Text(
                      formatTimeString(position),
                      style: const TextStyle(
                          color: Color(0xffFCDC4D),
                          fontStyle: FontStyle.italic))
                ])
              ],
            )
          ]),
          const Center(
            child: Text("Universidad Nacional de Colombia",

                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Color(0xffFCDC4D)
                )),
          )
        ])
        );
  }
}
