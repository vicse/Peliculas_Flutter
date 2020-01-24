class Cast {

  List<Actor> actores = new List();

  Cast.fromJsonList( List<dynamic> jsonList ) {

    if ( jsonList == null ) return;

    jsonList.forEach( (item) {

      final actor = Actor.fromJsonMap(item);
      actores.add(actor);

    });

  }


}


class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.fromJsonMap( Map<String, dynamic> json ) {

    this.character   = json['character'];
    this.castId      = json['cast_id'];
    this.creditId    = json['credit_id'];
    this.gender      = json['gender'];
    this.id          = json['id'];
    this.name        = json['name'];
    this.order       = json['order'];
    this.profilePath = json['profile_path'];


  }

  getFoto() {

    if ( profilePath == null ) {
      return 'https://www.trzcacak.rs/myfile/detail/385-3856300_no-avatar-png.png';
    }

    return 'https://image.tmdb.org/t/p/w500/$profilePath';

  }

}