import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:radiounal/src/business_logic/ScreenArguments.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool isHidden = true;

  final List<MenuItem> _menuTitles = [
    MenuItem('Programas Radio UNAL', "/content", null, ScreenArguments(
      'SITE',
      'RADIO',
      1
    )),
    MenuItem('Series Podcast Radio UNAL', "/content", null, ScreenArguments(
      'SITE',
      'PODCAST',
      1
    )),
    MenuItem('Favoritos ', "/favourites", Icons.favorite_border, ScreenArguments(
        'NONE',
        'NONE',
        0
    )),
    MenuItem('Siguiendo', "/followed", null, ScreenArguments(
        'NONE',
        'NONE',
        1
    )),
    MenuItem('Configuración', "/configurations", null, null),
    MenuItem('Acerca de esta App', "/about", null, null),
    MenuItem('Contáctenos', "/contacts", null, null),
    MenuItem('Política de privacidad', "/politics", null, null),
    MenuItem('Créditos', "/credits", null, null),
    MenuItem('Glosario', "/glossary", null, null)
  ];

  final List<MenuItem> _menuUrls = [
    MenuItem('UNIMEDIOS', "https://unimedios.unal.edu.co/", Icons.exit_to_app, null),
    MenuItem('Agencia UNAL', "https://agenciadenoticias.unal.edu.co/", null, null),
    MenuItem('Periódico UNAL', "https://periodico.unal.edu.co/", null, null),
    MenuItem('Televisión UNAL ', "https://television.unal.edu.co/", null, null)
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(40))),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                _buildFlutterLogo(),
                _buildContent(),
              ],
            )));
  }

  Widget _buildFlutterLogo() {
    return Container(
        child: Row(children: [
      IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close, color: Color(0xffFCDC4D))),
      Image.asset('assets/images/logo.png',
          width: MediaQuery.of(context).size.width * 0.5)
    ]));
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._buildListItems(),
        const Divider(
          color: Color(0xffFCDC4D),
          indent: 30,
          endIndent: 30,
        ),
        ..._buildListUrls(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];

    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(GestureDetector(
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName("/"));
            Navigator.pushNamed(context, _menuTitles[i].url,
              arguments: _menuTitles[i].arguments
            );
          },
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
              child: Row(
                children: [
                  Text(
                    _menuTitles[i].title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (_menuTitles[i].iconData != null)
                    Icon(_menuTitles[i].iconData, color: Colors.white)
                ],
              ))));
    }
    return listItems;
  }

  List<Widget> _buildListUrls() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuUrls.length; ++i) {
      if (i == 0) {
        listItems.add(Row(children: [
          GestureDetector(
            onTap: () {
              _launchURL(_menuUrls[i].url);
            },
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
                child: Row(children: [
                  Text(
                    _menuUrls[i].title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (_menuUrls[i].iconData != null)
                    Icon(_menuUrls[i].iconData, color: Colors.white)
                ])),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  isHidden = !isHidden;
                });
              },
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ))
        ]));
      } else {
        if (!isHidden) {
          listItems.add(GestureDetector(
            onTap: () {
              _launchURL(_menuUrls[i].url);
            },
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16),
                child: Row(children: [
                  Text(
                    _menuUrls[i].title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (_menuUrls[i].iconData != null) Icon(_menuUrls[i].iconData)
                ])),
          ));
        }
      }
    }
    return listItems;
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class MenuItem {
  late String _title;
  late String _url;
  late IconData? _iconData;
  late ScreenArguments? _arguments;

  MenuItem(this._title, this._url, this._iconData, this._arguments);

  IconData? get iconData => _iconData;

  set iconData(IconData? value) {
    _iconData = value!;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  ScreenArguments? get arguments => _arguments;

  set arguments(ScreenArguments? value) {
    _arguments = value;
  }
}
