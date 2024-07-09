import 'package:flutter/material.dart';

class InputFieldProvider with ChangeNotifier {
  final TextEditingController _fieldController = TextEditingController();

  bool _displayText = false;

  TextEditingController get fieldController => _fieldController;

  String get textContent => 'Hello ${_fieldController.text}! Have a great day!';

  bool get displayText => _displayText;

  void clearField() {
    _fieldController.text = '';
    _displayText = false;
    notifyListeners();
  }

  void displayTextPressed() {
    if (_fieldController.text.isNotEmpty) {
      _displayText = true;
      notifyListeners();
    }
  }
}
