// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:user_experior_example/characters/data/util/character_util.dart';

class Episode {
  final int id;
  final String name;
  final String airDate;
  final String episode;
  final List<String> characterIds;

  Episode(
      {required this.id,
      required this.name,
      required this.airDate,
      required this.episode,
      required this.characterIds});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'air_date': airDate,
      'episode': episode,
      'characterIds': CharacterUtil.getCharacterUrls(characterIds),
    };
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as int,
      name: json['name'] as String,
      airDate: json['air_date'],
      episode: json['episode'],
      characterIds:
          CharacterUtil.getCharacterIds(List<String>.from(json['characters'])),
    );
  }

  String toJson() => json.encode(toMap());
}
