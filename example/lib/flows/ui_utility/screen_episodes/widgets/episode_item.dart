import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior_example/characters/data/models/episode.dart';
import 'package:user_experior_example/characters/provider/characters_provider.dart';
import 'package:user_experior_example/utilities/app_routes.dart';
import 'package:user_experior_example/utilities/styles/text_styles.dart';

class EpisodeItem extends StatelessWidget {
  const EpisodeItem({super.key, required this.episode, required this.index});

  final Episode episode;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 5,
        shape: RoundedRectangleBorder(
            side: BorderSide.none, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          onTap: () {
            Provider.of<CharacterProvider>(context, listen: false)
                .episodeChosen(index);
            Navigator.of(context)
                .pushNamed(AppRoutes.utilityCharacters.description);
          },
          title: Column(
            children: [
              Text(episode.episode, style: gridLabelStyle),
              Text(episode.name, style: boldGridLabelStyle),
              Text(episode.airDate, style: gridLabelStyle),
            ],
          ),
        ),
      ),
    );
  }
}
