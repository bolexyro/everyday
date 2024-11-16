import 'package:flutter/material.dart';

class CircleBorderContainer extends StatelessWidget {
  const CircleBorderContainer({
    super.key,
    this.padding,
    this.margin,
    this.color = const Color(0xFFFFFFFF),
    this.child,
  });

  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(color: color),
        ),
      ),
      child: child,
    );
  }
}
