import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_controller.dart';
import 'providers/farm_controller.dart';
import 'providers/locale_controller.dart';
import 'router/app_router.dart';
import 'theme/farm_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  final localeController = LocaleController();
  await localeController.load();
  runApp(FarmRepellentApp(localeController: localeController));
}

class FarmRepellentApp extends StatelessWidget {
  final LocaleController localeController;
  const FarmRepellentApp({super.key, required this.localeController});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeController),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => FarmController()),
      ],
      child: Consumer<LocaleController>(
        builder: (context, localeCtrl, _) {
          return MaterialApp.router(
            title: 'KAVACH',
            debugShowCheckedModeBanner: false,
            theme: buildFarmTheme(),
            locale: localeCtrl.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
