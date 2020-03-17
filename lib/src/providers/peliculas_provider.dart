import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter_peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = '0087e2ee52ae1bc30ababdd80751dd3b';
  String _url = 'api.themoviedb.org';
  String _language = 'es-MX';

  int _popularesPage = 0;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> getEnCines() {
    return _get('3/movie/now_playing');
  }

  Future<List<Pelicula>> getPopulares() async {
    _popularesPage++;

    final resp = await _get('3/movie/popular', page: _popularesPage);

    _populares.addAll(resp);
    popularesSink(_populares);

    return resp;
  }

  Future<List<Pelicula>> _get(String path, {int page = 1}) async {
    final url = Uri.https(_url, path, {
      'api_key': _apikey,
      'language': _language,
      'page': page.toString()
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }
}