import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior_example/characters/data/models/character.dart';
import 'package:user_experior_example/characters/provider/characters_provider.dart';
import 'package:user_experior_example/utilities/app_routes.dart';
import 'package:user_experior_example/utilities/styles/text_styles.dart';

class CharacterItem extends StatelessWidget {
  const CharacterItem(
      {super.key, required this.character, required this.index});

  final Character character;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Provider.of<CharacterProvider>(context, listen: false)
                    .characterChosen(index);
                Navigator.of(context)
                    .pushNamed(AppRoutes.utilityCharacterDetails.description);
              },
              child: Ink.image(
                image: CachedNetworkImageProvider(character.imageUrl),
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
          ),
          Text(character.name, style: boldGridLabelStyle),
          Text(character.species, style: gridLabelStyle)
        ],
      ),
    );
  }
}
