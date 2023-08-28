

import 'package:radiounal/src/business_logic/firebase/firebaseLogic.dart';
import 'package:radiounal/src/data/models/programacion_model.dart';
import 'package:radiounal/src/data/repositories/radio_repository.dart';
import 'package:rxdart/rxdart.dart';

class RadioProgramacionBloc{

  final _repository = RadioRepository();

  final _subject = BehaviorSubject<List<ProgramacionModel>>();

  late FirebaseLogic firebaseLogic;
  late var fireProgramacionResults;
  List<ProgramacionModel> pragramacionList = [];

  fetchProgramacion() async {

    //OPCION 1
    //List<ProgramacionModel> modelList = await _repository.findProgramacion();

    //OPCION 2
    firebaseLogic = FirebaseLogic();
    firebaseLogic.findProgramacion().then(
            (value) => {

          fireProgramacionResults = value["jsonString"]["results"],
          pragramacionList = fireProgramacionResults
              .map<ProgramacionModel>((json) => ProgramacionModel.fromJson(json))
              .toList(),
            _subject.sink.add(pragramacionList)

    });

  }


  sendProgramacion(List<ProgramacionModel> modelList ){
    print(">>   sendProgrmacion");
    _subject.sink.add(modelList);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<ProgramacionModel>> get subject => _subject;
}