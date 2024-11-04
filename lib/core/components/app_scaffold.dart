import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
