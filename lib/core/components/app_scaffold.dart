import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.extendBodyBehindAppBar = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final bool extendBodyBehindAppBar; // extendBodyBehindAppBar: true,

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
