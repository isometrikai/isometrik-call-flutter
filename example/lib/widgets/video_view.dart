import 'package:better_player_plus/better_player_plus.dart';
import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  static const String route = Routes.videoViewer;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late BetterPlayerController controller;

  @override
  void initState() {
    super.initState();
    final url = Get.arguments;
    controller = BetterPlayerController(
      const BetterPlayerConfiguration(),
      betterPlayerDataSource: BetterPlayerDataSource.network(
        url,
        notificationConfiguration: const BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: 'Playing recording',
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: BetterPlayer(controller: controller),
      );
}
