import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/ResourcesFile/app_fonts.dart';
import 'package:test_project/ResourcesFile/app_strings.dart';
import 'package:test_project/ResourcesFile/app_window_config.dart';
import 'package:test_project/l10n/app_localizations.dart';
import 'package:test_project/screens/myhomePage.dart';
import 'package:test_project/providers/alert_provider.dart';
import 'package:test_project/providers/connection_provider.dart';
import 'package:test_project/providers/settings_provider.dart';
import 'package:test_project/services/logFile.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowsSingleInstance.ensureSingleInstance(
    args,
    "custom_identifier",
    onSecondWindow: (args) {
      print(args);
    },
  );
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    size: AppWindowConfig.windowSize,
    center: AppWindowConfig.centerWindow,
    titleBarStyle: TitleBarStyle.hidden,
    skipTaskbar: true,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAsFrameless();
    await Future.delayed(const Duration(milliseconds: 200));
    await windowManager.hide();
  });

  await LogService.init();
  runApp(AlertApp());
}

class AlertApp extends StatelessWidget {
  const AlertApp({super.key});


String getSystemLanguage() {
  try {
    final locale = ui.PlatformDispatcher.instance.locale;

    // Fallback to English if null or invalid
    if (locale.languageCode.isEmpty) {
      return 'en';
    }

    final langCode = locale.languageCode.toLowerCase();
    debugPrint("System language detected: $langCode");

    return langCode;
  } catch (e) {
    debugPrint("Error reading system language: $e");
    return 'en'; // fallback
  }
}


  @override
  Widget build(BuildContext context) {
    final systemLocale = getSystemLanguage();
    debugPrint("Detected system locale: $systemLocale");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: AppFonts.notoSans),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // locale: Locale(systemLocale),
        locale: Locale('ja'),
        home: const MyHomePage(title: AppStrings.appName),
        builder: (context, child) {
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
