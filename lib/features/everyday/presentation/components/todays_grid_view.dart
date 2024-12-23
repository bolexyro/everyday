import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/components/others.dart';
import 'package:myapp/core/connection_checker/domain/entities/connection_status.dart';
import 'package:myapp/core/connection_checker/presentation/providers/connection_provider.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/core/resources/data_state.dart';
import 'package:myapp/features/everyday/domain/entities/today.dart';
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
  bool _showScrollBackUpButton = false;
  final _scrollController = ScrollController();

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
                          if (!_showScrollBackUpButton) {
                            setState(() {
                              _showScrollBackUpButton = true;
                            });
                          }
                          widget.onScroll(extend: false);
                        }
                        if (scrollNotification.metrics.atEdge) {
                          if (scrollNotification.metrics.pixels ==
                              scrollNotification.metrics.minScrollExtent) {
                            _showScrollBackUpButton = false;
                          }
                          widget.onScroll(extend: true);
                        }
                      }
                      return false;
                    },
                    child: todays.isEmpty
                        ? const Center(child: Text('No todays yet'))
                        : GridView.count(
                            controller: _scrollController,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: todays
                                .map((today) => TodayBlock(
                                      today: today,
                                      canPlayToday: today.isAvailableLocal ||
                                          ref.watch(connectionProvider) ==
                                              ConnectionStatus.connected,
                                    ))
                                .toList(),
                          ),
                  ),
                  if (_showScrollBackUpButton)
                    ElevatedButton(
                        onPressed: () => _scrollController
                                .animateTo(
                                    _scrollController.position.minScrollExtent,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.decelerate)
                                .then((_) {
                              widget.onScroll(extend: true);
                              setState(() {
                                _showScrollBackUpButton = false;
                              });
                            }),
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder()),
                        child: const Icon(Icons.arrow_upward_outlined))
                ],
              );
            }),
      ),
    );
  }
}
