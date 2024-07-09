import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/characters/provider/characters_provider.dart';
import 'package:user_experior_example/flows/ui_utility/screen_episodes/widgets/episode_item.dart';
import 'package:user_experior_example/flows/ui_utility/widgets/rick_morty_app_bar.dart';

class EpisodesScreen extends StatelessWidget {
  const EpisodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CharacterProvider>(context, listen: false).fetchEpisodes();
    });
    return Scaffold(
        appBar: const RickMortyAppBar(),
        body: Consumer<CharacterProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: provider.episodes.length,
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (BuildContext context, int index) {
                      return _maskWhenNeeded(
                          EpisodeItem(
                              episode: provider.episodes[index], index: index),
                          index,
                          2);
                    },
                  );
          },
        ));
  }

  Widget _maskWhenNeeded(Widget child, int current, int threshold) {
    return child;// current % threshold == 0 ? UEMarker(child: child) : child;
  }
}
