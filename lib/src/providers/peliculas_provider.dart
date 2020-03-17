import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter_peliculas/src/models/pelicula_model.dart';
import 'package:flutter_peliculas/src/models/actor_model.dart';

class PeliculasProvider {
  String _apikey = '0087e2ee52ae1bc30ababdd80751dd3b';
  String _url = 'api.themoviedb.org';
  String _language = 'es-MX';

  int _popularesPage = 0;
  bool _cargando = false;

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
    if(_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final resp = await _get('3/movie/popular', page: _popularesPage);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;

    return resp;
  }

  Future<List<Pelicula>> buscarPelicula(String query) {
    return _get('3/search/movie', query: query);
  }

  Future<List<Pelicula>> _get(String path, {int page = 1, String query}) async {
    final url = Uri.https(_url, path, {
      'api_key': _apikey,
      'language': _language,
      'page': page.toString(),
      'query': query
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Actor>> getCast(String peliculaId) async {
    final url = Uri.https(_url, '3/movie/$peliculaId/credits', {
      'api_key': _apikey,
      'language': _language,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }
}