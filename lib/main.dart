import 'dart:developer';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pp_22/firebase_options.dart';
import 'package:pp_22/routes/routes.dart';
import 'package:pp_22/services/service_locator.dart';
import 'package:pp_22/theme/default_theme.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await _initApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    AppInfo(
      data: await AppInfoData.get(),
      child: const ScannerIDWorldCoins(),
    ),
  );
}

Future<void> _initApp() async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } on Exception catch (e) {
    log("Failed to initialize Firebase: $e");
  }

  await ServiceLocator.loadServices();
  await ServiceLocator.loadRepositories();
}

class ScannerIDWorldCoins extends StatelessWidget {
  const ScannerIDWorldCoins({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scanner ID World Coins',
      theme: DefaultTheme.get,
      routes: AppRoutes.get(context),
    );
  }
}
