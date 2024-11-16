import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:myapp/core/components/app_scaffold.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';

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
    player.open(
        Media(widget.today.localVideoPath ?? widget.today.remoteVideoUrl!));

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Video(controller: controller),
        ),
      ),
    );
  }
}
