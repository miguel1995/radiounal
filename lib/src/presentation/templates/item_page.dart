import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:radiounal/src/business_logic/bloc/podcast_episodio_bloc.dart';
import 'package:radiounal/src/business_logic/bloc/radio_emision_bloc.dart';
import 'package:radiounal/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/bottom_navigation_bar_radio.dart';
import 'package:radiounal/src/presentation/partials/menu.dart';

class ItemPage extends StatefulWidget {

  final String title;
  final String message;
  final int uid; //Indica el id del episodio de podcast o emisora de radio

  const ItemPage({Key? key, required this.title, required this.message, required this.uid}) : super(key: key);


  @override
  State<ItemPage> createState() => _ItemPageState();

}

class _ItemPageState extends State<ItemPage> {
  late String title;
  late String message;
  late int uid;

  final blocRadioEmision = RadioEmisionBloc();
  final blocPodcastEpisodio = PodcastEpisodioBloc();
  late dynamic element =  null;


  @override
  void initState() {
    super.initState();

    initializeDateFormatting('es_ES');
    Intl.defaultLocale = 'es_ES';

    title = widget.title;
    message = widget.message;
    uid = widget.uid;

    if (message == "RADIO") {
      blocRadioEmision.fetchEmision(uid);
      blocRadioEmision.subject.stream.listen((event) {
        setState(() {
          element = event[0];
        });

      });
    } else if (message == "PODCAST") {
      blocPodcastEpisodio.fetchEpisodio(uid);
      blocPodcastEpisodio.subject.stream.listen((event) {
        setState(() {
          element = event[0];
        });
      });
    }

  }

  @override
  Widget build(BuildContext context) {




    return  Scaffold(
      drawer: Menu(),
      appBar: AppBarRadio(),
      body: Center(
        child: Text((this.element!=null)?"${element.title}":""),
      ),
      //bottomNavigationBar: BottomNavigationBarRadio(),
    );
  }
}
