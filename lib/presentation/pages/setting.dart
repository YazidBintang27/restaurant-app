import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../providers/notification/local_notification_provider.dart';
import '../providers/setting/shared_preference_provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SharedPreferenceProvider>().getThemesAndNotificationValue();
    });
  }

  Future<void> _requestPermission() async {
    context.read<LocalNotificationProvider>().requestPermissions();
  }

  Future<void> _scheduleDailyElevenAMNotification() async {
    context
        .read<LocalNotificationProvider>()
        .scheduleDailyElevenAMNotification();
  }

  @override
  Widget build(BuildContext context) {
    final localNotificationProvider = context.read<LocalNotificationProvider>();
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Setting',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 18),
          ),
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft02,
              color: Theme.of(context).colorScheme.primary,
              size: 24.0,
            ),
          )),
      body: ConstrainedBox(
        constraints: BoxConstraints(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Klik ikon untuk mengatur notifikasi',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Consumer<SharedPreferenceProvider>(
                    builder: (context, value, child) => GestureDetector(
                      onTap: () async {
                        value.toggleNotification(value.notification);
                        if (value.notification) {
                          await _requestPermission();
                          await _scheduleDailyElevenAMNotification();
                        } else {
                          await localNotificationProvider.cancelNotification();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              value.notification
                                  ? 'Notifikasi diaktifkan'
                                  : 'Notifikasi dinonaktifkan',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: value.notification
                          ? HugeIcon(
                              icon: HugeIcons.strokeRoundedNotification01,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28.0,
                            )
                          : HugeIcon(
                              icon: HugeIcons.strokeRoundedNotificationOff01,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28.0,
                            ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Klik ikon untuk mengatur tema',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Consumer<SharedPreferenceProvider>(
                    builder: (context, value, child) => GestureDetector(
                      onTap: () => value.toggleTheme(value.themes),
                      child: value.themes
                          ? HugeIcon(
                              icon: HugeIcons.strokeRoundedMoon02,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28.0,
                            )
                          : HugeIcon(
                              icon: HugeIcons.strokeRoundedSun03,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28.0,
                            ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
