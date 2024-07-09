import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:user_experior_example/characters/repository/characters_repository.dart';
import 'package:user_experior_example/dependency_injection/injectable.dart';

import '../data/models/character.dart';
import '../data/models/episode.dart';

@injectable
class CharacterProvider extends ChangeNotifier {
  final CharacterRepository _characterRepository =
      dependencyProvider<CharacterRepository>();

  int _chosenEpisodeIndex = -1;
  int _chosenCharacterIndex = -1;
  List<Character> _characters = [];
  List<Episode> _episodes = [];
  List<Character> _episodeCharacters = [];

  bool _isLoading = false;

  List<Character> get characters => _characters;
  List<Episode> get episodes => _episodes;
  List<Character> get episodeCharacters => _episodeCharacters;
  int get chosenEpisodeIndex => _chosenEpisodeIndex;
  int get chosenCharacterIndex => _chosenCharacterIndex;
  bool get isLoading => _isLoading;
  Character get getCharacter => _episodeCharacters[_chosenCharacterIndex];

  Future<void> fetchCharacters() async {
    _isLoading = true;
    notifyListeners();

    try {
      _characters = await _characterRepository.fetchCharacters();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEpisodes() async {
    _isLoading = true;
    // _episodeCharacters = [];
    // _chosenEpisodeIndex = -1;
    notifyListeners();

    try {
      _episodes = await _characterRepository.fetchEpisodes();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEpisodeCharacters() async {
    _isLoading = true;
    notifyListeners();

    try {
      _episodeCharacters = await _characterRepository
          .fetchEpisodeCharacters(_episodes[_chosenEpisodeIndex].characterIds);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void episodeChosen(int index) {
    _chosenEpisodeIndex = index;
  }

  void characterChosen(int index) {
    _chosenCharacterIndex = index;
  }
}
