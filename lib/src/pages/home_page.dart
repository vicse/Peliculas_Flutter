import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';

import 'package:peliculas/src/widgets/card_swiper.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

import 'package:peliculas/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {

   final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.search ),
            onPressed: (){
              showSearch( 
                context: context, 
                delegate: DataSearch(),
                // query: 'Hola'
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0),
            _swiperTarjetas(),
            SizedBox(height: 40.0),
            _footer( context )
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),      
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        if ( snapshot.hasData ) {
          return CardSwiper( peliculas: snapshot.data );          
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            ),
          );
        }

      },
    );

  }

  Widget _footer( BuildContext context ) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,        
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead )
          ),
          SizedBox(height: 10.0),

          StreamBuilder(
            stream: peliculasProvider.popularesStream,      
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              
              if ( snapshot.hasData ) {
                return MovieHorizontal( 
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }

              //Signo de interrogación para saber si existe data que haga el foreach
              // snapshot.data?.forEach( (p) => print(p.title) );
            },
          )

        ],
      ),
    );


  }
}