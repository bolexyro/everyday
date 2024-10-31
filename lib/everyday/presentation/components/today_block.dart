import 'package:flutter/material.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/presentation/screens/today_screen.dart';

class TodayBlock extends StatelessWidget {
  const TodayBlock({
    super.key,
    required this.today,
    required this.onDragStartedOrEnded,
  });

  final Today today;
  final void Function(bool show) onDragStartedOrEnded;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: SizedBox(
        height: 200,
        width: 80,
        child: Image.memory(today.thumbnail),
      ),
      data: today,
      onDragStarted: () => onDragStartedOrEnded(true),
      onDragEnd: (draggableDetails) => onDragStartedOrEnded(false),
      onDragCompleted: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Today has been added to the recycle bin'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: GestureDetector(
        onTap: () =>
            context.navigator.push(context.route(TodayScreen(today: today))),
        child: Container(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.bottomCenter,
          width: 200,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: context.colorScheme.surfaceContainer,
          ),
          child: Column(
            children: [
              Expanded(
                child: Image.memory(
                  today.thumbnail,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: double.infinity,
                height: 30,
                color: context.colorScheme.onSecondaryContainer,
                child: Center(
                  child: Text(
                    today.date.formatDateWithShortDay,
                    style:
                        TextStyle(color: context.colorScheme.surfaceContainer),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
