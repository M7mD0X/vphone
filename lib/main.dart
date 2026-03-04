import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'services/vphone_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Immersive UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: VPhoneTheme.bgDeep,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const VPhoneApp());
}

class VPhoneApp extends StatelessWidget {
  const VPhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VPhoneProvider()),
      ],
      child: MaterialApp(
        title: 'VPhone',
        debugShowCheckedModeBanner: false,
        theme: VPhoneTheme.theme,
        home: const HomeScreen(),
        routes: {
          '/settings': (_) => const SettingsScreen(),
        },
      ),
    );
  }
}
