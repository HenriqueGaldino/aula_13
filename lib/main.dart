import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/user_profile.dart';
import 'screens/home_screen.dart';
import 'services/migration_service.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter());
  await Hive.openBox<UserProfile>('userProfileBox');

  await MigrationService.migrateIfNeeded();

  final settingsService = SettingsService();
  await settingsService.loadSettings();

  runApp(
    ChangeNotifierProvider(
      create: (_) => settingsService,
      child: const LocalVaultApp(),
    ),
  );
}

class LocalVaultApp extends StatelessWidget {
  const LocalVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();

    return MaterialApp(
      title: 'LocalVault',
      debugShowCheckedModeBanner: false,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
