// lib/repositories/character_repository.dart

import 'package:injectable/injectable.dart';
import 'package:user_experior_example/characters/data/character_networking_service.dart';
import 'package:user_experior_example/characters/data/models/character.dart';
import 'package:user_experior_example/characters/data/models/episode.dart';
import 'package:user_experior_example/dependency_injection/injectable.dart';

abstract class CharacterRepository {
  Future<List<Character>> fetchCharacters();
  Future<List<Episode>> fetchEpisodes();
  Future<List<Character>> fetchEpisodeCharacters(List<String> charactersIds);
}

@LazySingleton(as: CharacterRepository)
class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterNetworkingService _service =
      dependencyProvider<CharacterNetworkingService>();

  CharacterRepositoryImpl();

  @override
  Future<List<Character>> fetchCharacters() {
    return _service.fetchCharacters();
  }

  @override
  Future<List<Character>> fetchEpisodeCharacters(List<String> charactersIds) {
    return _service.fetchEpisodeCharacters(charactersIds);
  }

  @override
  Future<List<Episode>> fetchEpisodes() {
    return _service.fetchEpisodes();
  }
}
