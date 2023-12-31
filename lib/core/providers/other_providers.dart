import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

final gridViewToggleProvider = StateProvider<bool>((ref) => true);

final chewieControllerProvider =
    Provider.autoDispose.family<ChewieController, String>((ref, vlogLink) {
  final videoPlayerController =
      VideoPlayerController.networkUrl(vlogLink as Uri);
  return ChewieController(
    videoPlayerController: videoPlayerController,
    aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
    autoPlay: true,
    looping: true,
    // ... (you can customize other Chewie options here)
  );
});

final chewieFileControllerProvider =
    Provider.autoDispose.family<ChewieController, File>((ref, videoFile) {
  final videoPlayerController = VideoPlayerController.file(videoFile);
  return ChewieController(
    videoPlayerController: videoPlayerController,
    aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
    autoPlay: true,
    looping: true,
    // ... (you can customize other Chewie options here)
  );
});
