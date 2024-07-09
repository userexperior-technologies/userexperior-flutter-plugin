import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:user_experior_example/utilities/app_assets.dart';
import 'package:video_player/video_player.dart';

@injectable
class VideoProvider extends ChangeNotifier {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  VideoProvider() {
    _initializeVideo();
  }

  VideoPlayerController get controller => _controller;
  bool get isInitialized => _isInitialized;

  void _initializeVideo() {
    const videoAsset = AppAssets.demoVideo;
    _controller = VideoPlayerController.asset(videoAsset)
      ..initialize().then((_) {
        _isInitialized = true;
        notifyListeners();
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
