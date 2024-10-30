import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/everyday/presentation/components/everyday_grid_view.dart';
import 'package:myapp/everyday/presentation/components/today_caption_dialog.dart';
import 'package:myapp/everyday/presentation/providers/everyday_provider.dart';

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
  void initState() {
    ref.read(everydayProvider.notifier).getEveryday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Everyday'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.backup),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0)
            .add(const EdgeInsets.only(top: 8)),
        child: AllTodayGridView(onScroll: _extendFab),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final XFile? video =
              await picker.pickVideo(source: ImageSource.camera);
          if (video == null) {
            return;
          }
          if (context.mounted) {
            showAdaptiveDialog(
              context: context,
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