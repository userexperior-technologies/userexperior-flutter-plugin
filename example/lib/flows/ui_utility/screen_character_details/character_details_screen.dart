import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/characters/data/models/character.dart';
import 'package:user_experior_example/characters/provider/characters_provider.dart';
import 'package:user_experior_example/flows/ui_utility/provider/character_details_provider.dart';
import 'package:user_experior_example/flows/ui_utility/screen_character_details/widgets/bottom_sheet.dart';
import 'package:user_experior_example/flows/ui_utility/widgets/rick_morty_app_bar.dart';
import 'package:user_experior_example/utilities/styles/text_styles.dart';

class CharacterDetailsScreen extends StatelessWidget {
  const CharacterDetailsScreen({super.key, Object? arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const RickMortyAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 40.0,
            right: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _characterData(),
              const SizedBox(height: 50),
              _characterForm(context),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }

  Widget _characterData() {
    return Consumer<CharacterProvider>(
      builder: (context, provider, child) {
        final Character character = provider.getCharacter;
        return Column(
          children: [
            _characterImage(character),
            Text(character.name, style: labelHeaderStyle),
            Text('Species: ${character.species}', style: gridLabelStyle),
            Text('gender: ${character.gender}', style: gridLabelStyle),
            Text('origin: ${character.origin}', style: gridLabelStyle),
            Text('location: ${character.location}', style: gridLabelStyle),
          ],
        );
      },
    );
  }

  Container _characterImage(Character character) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      clipBehavior: Clip.antiAlias,
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

  Widget _characterForm(BuildContext context) {
    return Consumer<CharacterDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            const Text('To chat with the character, fill in the form:',
                style: labelHeaderStyle),
            const SizedBox(height: 15),
            UEMarker(child: _chatTextField(context, provider.nameController, 'Name')),
            const SizedBox(height: 15),
            UEMarker(child: _chatTextField(context, provider.topicController, 'Topic')),
            if (provider.isError) _formError(),
            const SizedBox(height: 15),
            _submitButton(context),
          ],
        );
      },
    );
  }

  TextField _chatTextField(
      BuildContext context, TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.yellow),
              borderRadius: BorderRadius.circular(15)),
          labelText: label),
      onChanged: (_) {
        Provider.of<CharacterDetailsProvider>(context, listen: false)
            .setIsError(false);
      },
    );
  }

  _formError() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text('Please fill all fields of the form', style: errorStyle),
    );
  }

  _submitButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: () {
          if (Provider.of<CharacterDetailsProvider>(context, listen: false)
              .submitPressed(context)) {
            showAppBottomSheet(context);
          }
        },
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(14)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
            backgroundColor: const MaterialStatePropertyAll(Colors.amber)),
        child: const Text('Submit', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
