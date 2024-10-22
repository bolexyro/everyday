import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myapp/components/video_caption_dialog.dart';
import 'package:myapp/models/category.dart';
import 'package:myapp/models/video.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _imagePicker = ImagePicker();

  final List<Video> _videos = [];

  void _addNewVideo(Video video) {
    setState(() {
      _videos.add(video);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: _videos.isEmpty
          ? const Center(
              child: Text('Nothing Here'),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                final video = _videos[index];
                print(video.time);
                return ListTile(
                  leading: Image.memory(video.thumbnail),
                  title: Text(video.title),
                  subtitle: Text(DateFormat('dd MMM yyyy').format(video.time)),
                );
              },
              itemCount: _videos.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final videoFile =
              await _imagePicker.pickVideo(source: ImageSource.camera);
          if (videoFile == null) {
            return;
          }

          if (mounted) {
            showDialog(
              // ignore: use_build_context_synchronously
              context: context,
              barrierDismissible: false,
              builder: (context) => VideoCaptionDialog(
                videoPath: videoFile.path,
                onVideoCreated: _addNewVideo,
              ),
            );
          }
        },
        child: const Icon(Icons.videocam),
      ),
    );
  }
}
