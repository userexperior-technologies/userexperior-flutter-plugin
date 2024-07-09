import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:user_experior_example/utilities/app_routes.dart';

@injectable
class LoginProvider extends ChangeNotifier {
  bool _isError = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isError => _isError;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  void setIsError(bool isError) {
    _isError = isError;
    notifyListeners();
  }

  void setEmailTextValue(String email) {
    _emailController.text = email;
    notifyListeners();
  }

  void setPasswordTextValue(String password) {
    _passwordController.text = password;
    notifyListeners();
  }

  void loginPressed(BuildContext context) {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      _emailController.text = '';
      _passwordController.text = '';
      Navigator.of(context)
          .pushReplacementNamed(AppRoutes.utilityEpisodes.description);
    } else {
      _isError = true;
      notifyListeners();
    }
  }

  void logout(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login.description);
  }
}
