class CharacterUtil {
  static List<String> getCharacterIds(List<String> characterUrls) {
    final List<String> characters = [];
    for (String url in characterUrls) {
      final String id = url.split('/').last;
      if (id.isNotEmpty) {
        characters.add(id);
      }
    }
    return characters;
  }

  static List<String> getCharacterUrls(List<String> characterIds) {
    final List<String> urls = List.generate(
        characterIds.length,
        (index) =>
            'https://rickandmortyapi.com/api/character/${characterIds[index]}');
    return urls;
  }
}
