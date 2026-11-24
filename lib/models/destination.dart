class Destination {
  final String id;
  final String nom;
  final String region;
  final String image;
  final double note;
  final int prix;
  final String categorie;
  final String description;
  final String duree;
  final int groupeMax;

  const Destination({
    required this.id,
    required this.nom,
    required this.region,
    required this.image,
    required this.note,
    required this.prix,
    required this.categorie,
    required this.description,
    required this.duree,
    required this.groupeMax,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'].toString(),
      nom: json['nom'] as String,
      region: json['region'] as String,
      image: json['image'] as String,
      note: (json['note'] as num).toDouble(),
      prix: json['prix'] as int,
      categorie: json['categorie'] as String,
      description: json['description'] as String,
      duree: json['duree'] as String,
      groupeMax: (json['groupeMax'] as int?) ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'region': region,
    'image': image,
    'note': note,
    'prix': prix,
    'categorie': categorie,
    'description': description,
    'duree': duree,
    'groupeMax': groupeMax,
  };
}
