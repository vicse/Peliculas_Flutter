import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Iron Man',
    'Thor',
    'Hulk 1',
    'Hulk 2',
    'Hulk 3',
    'Superman',
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitán America'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro Appbar

    return [
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: (){
          // print('CLICK!!!');
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        // print('Leading icon press');
        close( context, null );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar

    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe

    if ( query.isEmpty ) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {

        if ( snapshot.hasData ) {

          final peliculas = snapshot.data;

          return ListView(
            children: peliculas.map( (pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage( pelicula.getPosterImg() ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text( pelicula.title ),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close( context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList()
          );

        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

      },
    );

  }


  // @override
  //   Widget buildSuggestions(BuildContext context) {
  //     // Son las sugerencias que aparecen cuando la persona escribe

  //     // Si el query esta vacío entonces va a mostrar las películas recientes pero si no está vacio aplicamos el filtro where

  //     final listaSugerida = ( query.isEmpty ) 
  //                           ? peliculasRecientes
  //                           : peliculas.where( 
  //                             (p) => p.toLowerCase().startsWith(query.toLowerCase())
  //                           ).toList();



  //     return ListView.builder(

  //       itemCount: listaSugerida.length,
  //       itemBuilder: (context , i) {
  //         return ListTile(
  //           leading: Icon(Icons.movie),
  //           title: Text(listaSugerida[i]),
  //           onTap: (){
  //             seleccion = listaSugerida[i];  
  //             showResults(context);
  //           },
  //         );
  //       },

  //     );
  //   }



}