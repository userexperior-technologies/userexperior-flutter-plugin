// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String imageUrl;
  final String origin;
  final String location;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.imageUrl,
    required this.origin,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'image': imageUrl,
      'origin': origin,
      'location': location,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      gender: json['gender'] as String,
      imageUrl: json['image'] as String,
      origin: json['origin']['name'] as String,
      location: json['location']['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}
