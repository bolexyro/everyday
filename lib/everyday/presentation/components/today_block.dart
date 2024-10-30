import 'package:flutter/material.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/presentation/screens/today_screen.dart';

class TodayBlock extends StatelessWidget {
  const TodayBlock({
    super.key,
    required this.today,
  });

  final Today today;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  style: TextStyle(color: context.colorScheme.surfaceContainer),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
