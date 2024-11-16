import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/components/others.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
import 'package:myapp/features/everyday/presentation/components/delete_today_drag_target.dart';
import 'package:myapp/features/everyday/presentation/components/today_block.dart';
import 'package:myapp/features/everyday/presentation/providers/today_provider.dart';

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

  _showSnackBarAfterBuild() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.scaffoldMessenger.showSnackBar(appSnackbar(
            text:
                'Check your internet connection to sync your data, and refresh',
            color: AppColors.error));
      });
    }
  }

  late Future<DataState<List<Today>>> getTodaysFuture =
      ref.read(todayProvider.notifier).getTodays()
        ..then((dataState) {
          if (dataState is DataSuccessWithException<List<Today>>) {
            if (context.mounted) {
              _showSnackBarAfterBuild();
            }
          }
        });

  // @override
  // void initState() {
  //   // getTodaysFuture =
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          getTodaysFuture = ref.read(todayProvider.notifier).getTodays()
            ..then((dataState) {
              if (dataState is DataSuccessWithException<List<Today>>) {
                _showSnackBarAfterBuild();
              }
            }),
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: FutureBuilder(
            future: getTodaysFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final todays = ref.watch(todayProvider);

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
                    child: todays.isEmpty
                        ? const Center(child: Text('No todays yet'))
                        : GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: todays
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
