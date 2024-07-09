import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_experior_example/flows/ui_catalog/drawer_pages/page_video/video_provider.dart/video_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoProvider(),
      child: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          return Center(
            child: videoProvider.isInitialized
                ? AspectRatio(
                    aspectRatio: videoProvider.controller.value.aspectRatio,
                    child: VideoPlayer(videoProvider.controller),
                  )
                : const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
