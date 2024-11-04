import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/everyday/presentation/components/delete_today_drag_target.dart';
import 'package:myapp/everyday/presentation/components/today_block.dart';
import 'package:myapp/everyday/presentation/providers/everyday_provider.dart';

class AllTodayGridView extends ConsumerStatefulWidget {
  const AllTodayGridView({
    super.key,
    required this.onScroll,
  });
  final void Function({required bool extend}) onScroll;

  @override
  ConsumerState<AllTodayGridView> createState() => _AllTodayGridViewState();
}

class _AllTodayGridViewState extends ConsumerState<AllTodayGridView> {
  bool _isDeleteShowing = false;

  void _showHideDelete([bool show = true]) {
    setState(() => _isDeleteShowing = show);
  }

  late Future getEverydayFuture =
      ref.read(everydayProvider.notifier).getEveryday();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          getEverydayFuture = ref.read(everydayProvider.notifier).getEveryday(),
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: FutureBuilder<void>(
            future: getEverydayFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final everyday = ref.watch(everydayProvider);

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is UserScrollNotification) {
                        if (scrollNotification.direction ==
                                ScrollDirection.forward ||
                            scrollNotification.direction ==
                                ScrollDirection.reverse) {
                          widget.onScroll(extend: false);
                        } else if (scrollNotification.metrics.atEdge) {
                          widget.onScroll(extend: true);
                        }
                      }
                      return false;
                    },
                    child: everyday.isEmpty
                        ? const Center(child: Text('No todays yet'))
                        : GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: everyday
                                .map((category) => TodayBlock(
                                      today: category,
                                      onDragStartedOrEnded: _showHideDelete,
                                    ))
                                .toList(),
                          ),
                  ),
                  if (_isDeleteShowing) const DeleteTodayDragTarget()
                ],
              );
            }),
      ),
    );
  }
}
