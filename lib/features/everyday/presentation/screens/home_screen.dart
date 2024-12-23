import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/core/components/app_scaffold.dart';
import 'package:myapp/features/everyday/presentation/components/todays_grid_view.dart';
import 'package:myapp/features/everyday/presentation/components/profile_dialog.dart';
import 'package:myapp/features/everyday/presentation/components/today_caption_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final picker = ImagePicker();

  bool _fabIsExtended = true;

  void _extendFab({required bool extend}) {
    setState(() {
      _fabIsExtended = extend;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Everyday'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.offline_pin_outlined,
            ),
          ),
          const Gap(12),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) => const ProfileDialog(),
              ),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: CachedNetworkImageProvider(
                    ref.read(authProvider).user!.photoUrl),
              ),
            ),
          ),
        ],
      ),
      body: AllTodayGridView(onScroll: _extendFab),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final XFile? video =
              await picker.pickVideo(source: ImageSource.gallery);
          if (video == null) {
            return;
          }
          if (context.mounted) {
            showAdaptiveDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return TodayCaptionDialog(videoPath: video.path);
              },
            );
          }
        },
        extendedIconLabelSpacing: _fabIsExtended ? 10 : 0,
        extendedPadding:
            _fabIsExtended ? null : const EdgeInsets.symmetric(horizontal: 16),
        label: AnimatedSize(
          alignment: Alignment.centerLeft,
          duration: const Duration(milliseconds: 100),
          child: _fabIsExtended ? const Text('Today') : Container(),
        ),
        icon: const Icon(Icons.videocam),
      ),
    );
  }
}
