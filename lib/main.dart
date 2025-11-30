import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/screens/myhomePage.dart';
import 'package:test_project/providers/alert_provider.dart';
import 'package:test_project/providers/connection_provider.dart';
import 'package:test_project/providers/settings_provider.dart';
import 'package:test_project/resourcesFile.dart/app_strings.dart';
import 'package:test_project/resourcesFile.dart/app_window_config.dart';
import 'package:test_project/resourcesFile.dart/app_fonts.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: AppFonts.notoSans),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: AppStrings.appName),
        builder: (context, child) {
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
