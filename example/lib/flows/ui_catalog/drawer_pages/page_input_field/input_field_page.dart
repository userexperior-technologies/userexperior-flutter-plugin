import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior/user_experior.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_input_field/input_field_provider/input_field_provider.dart';
import 'package:user_experior_example/utilities/styles/text_styles.dart';

class InputFieldPage extends StatelessWidget {
  const InputFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text('Enter your name', style: labelStyle),
            _nameField(),
            _sendButton(context),
            _clearButton(context),
            _helloText(),
          ],
        ),
      ),
    );
  }

  Widget _clearButton(BuildContext context) {
    return _formButton('Clear', Colors.red,
        Provider.of<InputFieldProvider>(context, listen: false).clearField);
  }

  Widget _sendButton(BuildContext context) {
    return _formButton(
        'Send',
        Colors.green,
        Provider.of<InputFieldProvider>(context, listen: false)
            .displayTextPressed);
  }

  Widget _nameField() {
    return Consumer<InputFieldProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: UEMarker(child: TextField(
          controller: provider.fieldController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            labelText: 'Name',
          ),
        ),
      ));
    });
  }

  Widget _formButton(String text, Color color, Function onClick) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
          onPressed: () {
            onClick();
          },
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
              backgroundColor: MaterialStatePropertyAll(color),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)))),
          child: Text(text, style: buttonStyle)),
    );
  }

  Widget _helloText() {
    return Consumer<InputFieldProvider>(builder: (context, provider, child) {
      return provider.displayText
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                provider.textContent,
                style: labelHeaderStyle,
                textAlign: TextAlign.center,
              ),
            )
          : const SizedBox();
    });
  }
}
