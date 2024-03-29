import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class PatchMeVideo extends StatefulWidget {
  const PatchMeVideo({super.key});

  @override
  State<PatchMeVideo> createState() => _PatchMeVideoState();
}

class _PatchMeVideoState extends State<PatchMeVideo> {
  var isLoading = true;
  late VideoPlayerController _controller;
  late CustomVideoPlayerController _customVideoPlayerController;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(
    settingsButtonAvailable: false,
    showFullscreenButton: false,
    playButton: Icon(
      Icons.play_circle,
      color: Colors.white,
    ),
    pauseButton: Icon(
      Icons.pause_circle,
      color: Colors.white,
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/patch-me-story.mov');
    _controller.initialize().then((_) => setState(() {
          isLoading = false;
        }));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _controller,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController);
    }
  }
}
