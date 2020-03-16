import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = '0087e2ee52ae1bc30ababdd80751dd3b';
  String _url = 'api.themoviedb.org';
  String _language = 'es-MX';

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }
}