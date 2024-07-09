import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_experior_example/characters/data/models/character.dart';
import 'package:user_experior_example/utilities/styles/text_styles.dart';

class GridItem extends StatelessWidget {
  final Character character;

  const GridItem({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _characterImage(),
          _characterInfo(),
        ],
      ),
    );
  }

  Padding _characterInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            character.name,
            style: boldGridLabelStyle,
          ),
          const SizedBox(height: 4),
          Text(character.species, style: gridLabelStyle),
        ],
      ),
    );
  }

  Expanded _characterImage() {
    return Expanded(
      child: CachedNetworkImage(
        imageUrl: character.imageUrl,
        errorWidget: (context, url, error) =>
            const Icon(Icons.error_outline_rounded),
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        fit: BoxFit.cover,
      ),
    );
  }
}
