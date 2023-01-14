import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseLogic{

  late final FirebaseFirestore db;


  FirebaseLogic(){
    db = FirebaseFirestore.instance;
  }

  Future<bool> agregarFavorito(uid, message, tipo, userId)async{

    bool flag = false;

    // Agragar un favorito a la base de datos en firebase
    final newDocument = <String, dynamic>{
      "uid": uid,
      "sitio": message, //RADIO o PODCAST
      "tipo": tipo,
      "userId": userId
    };

      // Add a new document with a generated ID
      await db.collection("favoritos").add(newDocument).then((DocumentReference doc) =>
      {
          if(doc.id != null){
            //print('DocumentSnapshot added with ID: ${doc.id}');
            flag = true
          }
      }

    );

    return flag;
  }

  Future<bool> validateFavorite(uid, userId)  async {
    // Verifica si ya se encuentra en el listado de mis favoritos en Firebase
    bool flag = false;
    await db
        .collection("favoritos")
        .where("uid", isEqualTo: uid)
        .where("userId", isEqualTo: userId)
        .get()
        .then(
          (res) => {
              if(res.docs.length > 0){
                flag = true
              }

      },
      onError: (e) => print("Error completing: $e"),
    );

    return flag;

  }

  Future<bool> eliminarFavorite(uid, userId)  async {
    bool flag = false;

    // Verifica si ya se encuentra en el listado de mis favoritos en Firebase
    await db
        .collection("favoritos")
        .where("uid", isEqualTo: uid)
        .where("userId", isEqualTo: userId)
        .get()
        .then(
          (snapshot) async => {
          for (var doc in snapshot.docs) {
                await doc.reference.delete().then(
                        (value) => {

                  }
                )
          }

      },
      onError: (e) => print("Error completing: $e"),
    );

    return flag;

  }

  Future<List<Map<String, dynamic>>> findFavoriteByUserUid(userId)  async {
    List<Map<String, dynamic>> listDocs = [];

    //Busca todos los favoritos de un usuario
    await db
        .collection("favoritos")
        .where("userId", isEqualTo: userId)
        .get()
        .then(
          (snapshot) async => {
          listDocs = snapshot.docs.map((doc) => doc.data()).toList()

      },
      onError: (e) => print("Error completing: $e"),
    );

    return listDocs;

  }

}