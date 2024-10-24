import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:myapp/models/today.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({
    super.key,
    required this.today,
  });

  final Today today;

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    player = Player();
    controller = VideoController(player);
    player.open(Media(widget.today.videoPath));

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Video(controller: controller),
        ),
      ),
    );
  }
}
