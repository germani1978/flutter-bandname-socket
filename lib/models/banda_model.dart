
class Band {

  String id;
  String name;
  int votos;

  Band({required this.id,required this.name,required this.votos});

  factory Band.fromMap (Map<String, dynamic> obj ) => 
        Band(
          id: obj.containsKey('id') ? obj['id'] : 'no-id', 
          name: obj.containsKey('name') ? obj['name'] : 'no-name', 
          votos: obj.containsKey('votos') ? obj['votos'] : 0
        );
  
  
}