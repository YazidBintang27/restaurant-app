import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/presentation/providers/setting/shared_preference_provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<SharedPreferenceProvider>()
        .getThemesAndNotificationValue());
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      context.go('/main');
    });

    return Scaffold(
      body: Center(
        child: Text(
          'Resto.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }
}
