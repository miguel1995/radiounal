import 'package:flutter/material.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliticsPage extends StatelessWidget {
  const PoliticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: const Menu(),
      appBar: const AppBarRadio(),
      body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).primaryColor)
              ),
            child: Column(
              children: <Widget>[
                 Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Política de privacidad',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          decorationColor: Theme.of(context).appBarTheme.foregroundColor,
                          decoration: TextDecoration.underline

                      ),
                    ),
                  ),
                ),
                const Text(
                    'CircularUNAL usa información almacenada en el dispositivo donde se encuentra instalada. Esta información consiste en:\n'),
                Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text('Estado del dispositivo: activo, inactivo.'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                'Estado de conexión a internet, puede usar datos del dispositivo.'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                'Registro de la consulta de contenidos a través de la aplicación.'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                'Tokens (identificadores generados para la aplicación móvil, que no corresponden al ID de cada dispositivo) para la funcionalidad de notificaciones.'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                'Preferencias de los usuarios acerca de los eventos (para notificaciones).'),
                          ),
                        ],
                      ),
                    ])),
                const Text(
                    '\nEsta información es recopilada en la plataforma Firebase, siguiendo los términos de servicio de las API de Google.'),
                const Text('\nEsta información es usada con los siguientes fines:\n'),
                Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                'Advertir sobre nuevos contenidos o posibles cambios en los mismos.'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                'Llevar estadísticas de los contenidos vistos a través de la aplicación.'),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text("• "),
                          Expanded(
                            child: Text(
                                'Ofrecer un servicio de notificaciones con base en las preferencias del usuario.'),
                          ),
                        ],
                      ),
                    ])),
                const Text(
                    '\nParte de la información almacenada en Firebase podría usarse en el futuro con fines estadísticos sobre el uso de la aplicación.'),
                const Text(
                    '\nEn ningún caso se usará la información recopilada con fines comerciales que puedan beneficiar a terceros; tampoco se entregará a personas o entidades externas a la Universidad Nacional de Colombia.'),
                const Text(
                    '\nSe hace uso de los servicios de localización de cada dispositivo para indicar la ubicación de un evento seleccionado. Las ubicaciones de los dispositivos no son recopiladas; sin embargo, puede almacenarse en la plataforma gestora de mapas del dispositivo (Google Maps) si se tiene habilitada la opción correspondiente.'),
                 Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Propiedad intelectual',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                RichText(

                  text: TextSpan(
                    style:   TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'AncizarSans',
                        color: Theme.of(context).primaryColor
                    ),


                    children: const <TextSpan>[
                        TextSpan(
                          text: 'Los contenidos (imágenes, textos y videos) provistos a través de '


                ),
                       TextSpan(
                          text: 'RadioUNAL',
                          style:  TextStyle(fontStyle: FontStyle.italic)),
                       TextSpan(
                          text:
                          'pertenecen a la Universidad Nacional de Colombia, de conformidad con el Acuerdo 035 de 2003 del Consejo Académico, “Por el cual se expide el reglamento sobre Propiedad Intelectual en la Universidad Nacional de Colombia”'),
                    ],
                  ),
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("• "),
                        Expanded(
                            child:  RichText(
                              text:  TextSpan(

                                style:  TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'AncizarSans',
                                    color: Theme.of(context).primaryColor

                                ),

                                children: const <TextSpan>[

                                   TextSpan(
                                      text: 'Director Nacional de Unimedios: ',
                                      style:
                                       TextStyle(fontWeight: FontWeight.bold)),

                                   TextSpan(
                                      text: 'Fredy Fernando Chaparro Sanabria'),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child:  RichText(
                              text:  TextSpan(
                                children: <TextSpan>[
                                   TextSpan(
                                      text: 'Idea conceptual: ',
                                      style:
                                       TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                                   TextSpan(text: 'Jaime Franky Rodríguez',
                                       style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                                   ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child: RichText(
                              text:  TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                      'Diseño, desarrollo, implementación y normativa para web: ',
                                      style:
                                       TextStyle(fontWeight: FontWeight.bold,
                                           color: Theme.of(context).primaryColor
                                       )),
                                   TextSpan(
                                      text: 'Oficina de Medios Digitales - Unimedios',
                                       style:
                                       TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                                   ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child: RichText(
                              text:  TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Dirección de la Oficina de Medios Digitales: ',
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor
                                      )),
                                   TextSpan(text: 'Martha Lucía Chaves Muñoz',
                                       style: TextStyle(fontWeight: FontWeight.bold,
                                           color: Theme.of(context).primaryColor
                                       )
                                   ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("• "),
                        Expanded(
                            child:  RichText(
                              text:  TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Ingeniero de desarrollo: ',
                                      style:
                                       TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                                   TextSpan(text: 'Miguel Andrés Torres Chavarro',
                                       style: TextStyle(fontWeight: FontWeight.bold,
                                           color: Theme.of(context).primaryColor
                                       )
                                   ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child:  RichText(
                              text:  TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                   TextSpan(
                                      text: 'Apoyo en desarrollo: ',
                                      style:
                                       TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                                   TextSpan(
                                      text: 'Giovanni Romero Pérez',
                                       style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                                   ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child:  RichText(
                              text:  TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent

                                children: <TextSpan>[
                                   TextSpan(
                                      text: 'Diseño gráfico en conjunto: ',
                                      style:
                                       TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                                   TextSpan(
                                      text:
                                      'María Teresa Naranjo Castillo',
                                       style:
                                       TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child:  RichText(
                              text:  TextSpan(
                                children: <TextSpan>[
                                   TextSpan(
                                      text: 'Webmaster: ',
                                      style:
                                       TextStyle(fontWeight: FontWeight.bold,
                                           color: Theme.of(context).primaryColor
                                       )),
                                   TextSpan(
                                      text: 'Francisco Javier Morales  Ducuara, Aldemar Hernandez Torres',
                                       style:
                                       TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                                   ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ]),
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('\nPublicado por la Oficina de Medios Digitales')),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('\nUnidad de Medios de Comunicación – Unimedios')),
                Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        onTap: () async {
                          //launch('mailto:mediosdigitales@unal.edu.co');
                          String email = Uri.encodeComponent("mediosdigitales@unal.edu.co");

                          Uri mail = Uri.parse("mailto:$email");
                          if (await launchUrl(mail)) {
                          //email app opened
                          }else{
                          //email app is not opened
                          }
                        },
                        child: Text(
                          '\nmediosdigitales@unal.edu.co',
                          style: TextStyle(color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ))),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('\nPBX: (1) 316 5000 ext. 18280-18120')),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('\nUniversidad Nacional de Colombia')),
              ],
            ),
          )),
      //bottomNavigationBar: BottomNavigationBarRadio(),

    );
  }
}
