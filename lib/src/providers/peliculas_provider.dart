

import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

class PeliculasProvider {

  String _apiKey = '7a3ed0e10200b12f47a10cdd60fcbec7';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _polularesPage = 0;
  bool _cargando = false; 

  List<Pelicula> _populares = new List();

  // Sin broadcast solo funciona con un listener
  final _polularesStreamController = StreamController<List<Pelicula>>.broadcast();

  // Añadir películas
  Function( List<Pelicula> ) get popularesSink => _polularesStreamController.sink.add;

  // Escuchar películas
  Stream<List<Pelicula>> get popularesStream => _polularesStreamController.stream;


  void disposeStreams() {
    _polularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {

    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    // print( peliculas.items[1].title );

    // print( decodedData['results'] );
  

    return peliculas.items;


  }

  Future<List<Pelicula>> getEnCines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language
    });

    return await _procesarRespuesta(url);

  }

  Future<List<Pelicula>> getPopulares() async {

    if ( _cargando ) return[];

    _cargando = true;

    _polularesPage++;

    // print('Cargando siguientes');

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'   : _apiKey,
      'language'  : _language,
      'page'      : _polularesPage.toString()
    });


    final resp = await _procesarRespuesta(url);

    // AddAll para añadir la lista resp a populares
    _populares.addAll(resp);
    popularesSink( _populares );

    _cargando = false;

    return resp;

  }

  Future<List<Actor>> getCast( String peliId ) async {

    final url = Uri.https(_url , '3/movie/$peliId/credits', {
      
      'api_key': _apiKey,
      'language': _language

    });

    final respuesta = await http.get(url);

    final decodeData = jsonDecode( respuesta.body );

    final cast = new Cast.fromJsonList(decodeData['cast']);

    return cast.actores;

  }

  Future<List<Pelicula>> buscarPelicula( String query ) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apiKey,
      'language': _language,
      'query'   : query,
      'include_adult' : 'true'
    });

    return await _procesarRespuesta(url);

  }



}