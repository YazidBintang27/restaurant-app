import 'package:flutter/material.dart';
import 'package:restaurant_app/data/local/services/local_notification_service.dart';
import 'package:restaurant_app/data/local/services/shared_preference_service.dart';
import 'package:restaurant_app/data/local/services/sqlite_service.dart';
import 'package:restaurant_app/data/remote/service/api_service.dart';
import 'package:restaurant_app/presentation/providers/database/local_database_provider.dart';
import 'package:restaurant_app/presentation/providers/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/presentation/providers/detail/restaurant_review_provider.dart';
import 'package:restaurant_app/presentation/providers/home/restaurant_list_provider.dart';
import 'package:restaurant_app/presentation/providers/main/index_nav_provider.dart';
import 'package:restaurant_app/presentation/providers/notification/local_notification_provider.dart';
import 'package:restaurant_app/presentation/providers/search/restaurant_search_provider.dart';
import 'package:restaurant_app/presentation/providers/setting/shared_preference_provider.dart';
import 'package:restaurant_app/presentation/routes/app_router.dart';
import 'package:restaurant_app/presentation/styles/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => IndexNavProvider()),
      Provider(create: (context) => ApiService()),
      ChangeNotifierProvider(
          create: (context) =>
              RestaurantListProvider(context.read<ApiService>())),
      ChangeNotifierProvider(
          create: (context) =>
              RestaurantSearchProvider(context.read<ApiService>())),
      ChangeNotifierProvider(
          create: (context) =>
              RestaurantDetailProvider(context.read<ApiService>())),
      ChangeNotifierProvider(
          create: (context) =>
              RestaurantReviewProvider(context.read<ApiService>())),
      Provider(create: (context) => SqliteService()),
      ChangeNotifierProvider(
          create: (context) =>
              LocalDatabaseProvider(context.read<SqliteService>())),
      Provider(create: (context) => SharedPreferenceService(prefs)),
      ChangeNotifierProvider(
          create: (context) => SharedPreferenceProvider(
              context.read<SharedPreferenceService>())),
      Provider(
        create: (context) => LocalNotificationService()..init()..configureLocalTimeZone(),
      ),
      ChangeNotifierProvider(
        create: (context) => LocalNotificationProvider(
          context.read<LocalNotificationService>(),
        )..requestPermissions(),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<SharedPreferenceProvider>(context).themes
          ? ThemeMode.light
          : ThemeMode.dark,
      routerConfig: AppRouter.router,
    );
  }
}
