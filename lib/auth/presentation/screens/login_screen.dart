import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:myapp/auth/presentation/providers/auth_provider.dart';
import 'package:myapp/core/app_colors.dart';
import 'package:myapp/core/components/others.dart';
import 'package:myapp/core/extensions.dart';
import 'package:myapp/core/resources/data_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isAuthenticating = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 6, 39, 1),
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Gap(32),
                  Image.asset(
                    'everyday_logo'.png,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25)),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'google_logo'.png,
                      height: 50,
                      width: 50,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Continue to Everyday',
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isAuthenticating
                          ? null
                          : () async {
                              setState(() {
                                _isAuthenticating = true;
                                _controller.repeat();
                              });
                              final dataState =
                                  await ref.read(authProvider.notifier).login();
                              setState(() {
                                _isAuthenticating = false;
                                _controller.stop();
                                _controller.reset();
                              });
                              if (dataState is DataException) {
                                if (context.mounted) {
                                  context.scaffoldMessenger
                                      .showSnackBar(appSnackbar(
                                    text: dataState.exceptionMessage ??
                                        'An unexpected error occurred',
                                    color: AppColors.error,
                                    seconds: 3,
                                  ));
                                }
                              }
                            },
                      icon: _isAuthenticating
                          ? SizedBox.square(
                              dimension: 24,
                              child: RotationTransition(
                                turns: Tween<double>(begin: 0, end: 1)
                                    .animate(_controller),
                                child: Image.asset(
                                  'everyday_logo'.png,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Image.asset(
                              'google_logo'.png,
                              height: 24,
                              width: 24,
                            ),
                      label: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
