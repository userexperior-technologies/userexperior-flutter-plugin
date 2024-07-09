import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class AnimationProvider extends ChangeNotifier {
  bool _sizeAnimation = false;
  bool _rotateAnimation = false;
  bool _positionAnimation = false;
  bool _opacityAnimation = false;

  bool get sizeAnimation => _sizeAnimation;
  bool get rotateAnimation => _rotateAnimation;
  bool get positionAnimation => _positionAnimation;
  bool get opacityAnimation => _opacityAnimation;

  void toggleSizeAnimation(bool value) {
    _sizeAnimation = value;
    notifyListeners();
  }

  void toggleRotateAnimation(bool value) {
    _rotateAnimation = value;
    notifyListeners();
  }

  void togglePositionAnimation(bool value) {
    _positionAnimation = value;
    notifyListeners();
  }

  void toggleOpacityAnimation(bool value) {
    _opacityAnimation = value;
    notifyListeners();
  }
}
