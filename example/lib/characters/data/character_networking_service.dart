import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'models/character.dart';
import 'models/episode.dart';

@lazySingleton
class CharacterNetworkingService {
  static const String _baseUrl = 'https://rickandmortyapi.com/api';
  static const String _charactersEndpoint = '/character';
  static const String _episodesEndpoint = '/episode';

  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(Uri.parse(_baseUrl + _charactersEndpoint));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['results'];
      return data
          .map((characterJson) => Character.fromJson(characterJson))
          .toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  Future<List<Episode>> fetchEpisodes() async {
    final response = await http.get(Uri.parse(_baseUrl + _episodesEndpoint));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['results'];
      final list = data.map((json) => Episode.fromJson(json)).toList();
      return list;
    } else {
      throw Exception('Failed to load characters');
    }
  }

  Future<List<Character>> fetchEpisodeCharacters(
      List<String> charactersIds) async {
    final String characters = charactersIds.join(',');
    final response =
        await http.get(Uri.parse('$_baseUrl$_charactersEndpoint/$characters'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final list = data
          .map((characterJson) => Character.fromJson(characterJson))
          .toList();
      return list;
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
