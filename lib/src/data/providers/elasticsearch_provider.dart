import 'package:http/http.dart' as http;
import 'package:radiounal/src/data/models/info_model.dart';
import 'dart:convert';

import '../models/countriesNow/ciudad_model.dart';
import '../models/countriesNow/departamento_model.dart';
import '../models/countriesNow/pais_model.dart';

class ElasticSearchProvider {

  final _hostDomain = "168.176.236.22:9200/";
  final _urlRadioyPosdcast = "radio_unal%2Cpodcast_unal/_search?pretty=true";


  //consume todos los contenidos de http://radio.unal.edu.co/rest/noticias/app/search
  Future<Map<String, dynamic>> getSearch(
      String query,
      int from,
      int size,
      ) async {

    var url = Uri.parse('http://$_hostDomain$_urlRadioyPosdcast');
    Map<String, dynamic> map = {};

    var body = jsonEncode(<String, dynamic>{
      "from":from,
      "size":size,
      "sort":[
        {
          "recordDate":{
            "order":"desc"
          }
        }
      ],
      "query":{
        "bool":{
          "must":{
            "query_string":{
              "query":"*${query}*"
            }
          },
          "filter":{
            "bool":{
              "must":[

              ]
            }
          }
        }
      },
      "_source":[
        "id",
        "title",
        "imagen",
        "date",
        "recordDate",
      ]
    });
    /*print(url);
    print(body);*/

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic ZWxhc3RpY19idXNjYWRvcjprMXVqN1NuRlFibDRKRDIzZlU='
        },
        body: body);
    /*print("### elastic 3333");
    print(response);
    print(utf8.decode(response.bodyBytes));*/
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      final parsed = json.decode(responseBody);
      int total = 1;
      if(parsed["hits"]["total"]["value"]!=null){
        total = parsed["hits"]["total"]["value"];
      }

      map["result"] = parsed["hits"]["hits"];
      map["info"] = InfoModel(
          total,
          (total/size).ceil(),
          "", ""
      );

      return map;

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }




}