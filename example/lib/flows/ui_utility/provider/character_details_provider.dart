import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class CharacterDetailsProvider extends ChangeNotifier {
  bool _isError = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();

  bool get isError => _isError;
  TextEditingController get nameController => _nameController;
  TextEditingController get topicController => _topicController;

  void setIsError(bool isError) {
    _isError = isError;
    notifyListeners();
  }

  void setNameTextValue(String name) {
    _nameController.text = name;
    notifyListeners();
  }

  void setTopicTextValue(String topic) {
    _topicController.text = topic;
    notifyListeners();
  }

  bool submitPressed(BuildContext context) {
    if (_nameController.text.isNotEmpty && _topicController.text.isNotEmpty) {
      return true;
    } else {
      _isError = true;
      notifyListeners();
      return false;
    }
  }
}
