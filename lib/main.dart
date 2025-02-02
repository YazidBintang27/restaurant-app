import 'package:flutter/material.dart';
import 'package:restaurant_app/data/service/api_service.dart';
import 'package:restaurant_app/presentation/providers/home/restaurant_list_provider.dart';
import 'package:restaurant_app/presentation/providers/main/index_nav_provider.dart';
import 'package:restaurant_app/presentation/providers/search/restaurant_search_provider.dart';
import 'package:restaurant_app/presentation/providers/theme/theme_provider.dart';
import 'package:restaurant_app/presentation/routes/app_router.dart';
import 'package:restaurant_app/presentation/styles/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
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
      ChangeNotifierProvider(create: (context) => ThemeProvider())
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
      themeMode: Provider.of<ThemeProvider>(context).isDark ? ThemeMode.light : ThemeMode.dark,
      routerConfig: AppRouter.router,
    );
  }
}
