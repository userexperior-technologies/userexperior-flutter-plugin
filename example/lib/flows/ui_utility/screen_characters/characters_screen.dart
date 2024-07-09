import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/characters/provider/characters_provider.dart';
import 'package:user_experior_example/flows/ui_utility/screen_characters/widgets/character_item.dart';
import 'package:user_experior_example/flows/ui_utility/widgets/rick_morty_app_bar.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CharacterProvider>(context, listen: false)
          .fetchEpisodeCharacters();
    });
    return Scaffold(
        appBar: const RickMortyAppBar(),
        body: Consumer<CharacterProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: provider.episodeCharacters.length,
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (BuildContext context, int index) {
                      return _maskWhenNeeded(CharacterItem(
                          character: provider.episodeCharacters[index],
                          index: index), index, 3);
                    },
                  );
          },
        ));
  }
  Widget _maskWhenNeeded(Widget child, int current, int threshold) {
    return current % threshold == 0 ? UEMarker(child: child) : child;
  }
}
