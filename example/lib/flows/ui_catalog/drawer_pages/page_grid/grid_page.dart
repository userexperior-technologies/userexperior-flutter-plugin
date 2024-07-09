import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior_example/characters/provider/characters_provider.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_grid/widgets/grid_item.dart';

class GridPage extends StatelessWidget {
  const GridPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CharacterProvider>(context, listen: false).fetchCharacters();
    });
    return Consumer<CharacterProvider>(
      builder: (context, provider, child) {
        return provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                padding: const EdgeInsets.all(10),
                itemCount: provider.characters.length,
                itemBuilder: (context, index) {
                  final character = provider.characters[index];
                  return GridItem(character: character);
                },
              );
      },
    );
  }
}
