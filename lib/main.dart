import 'package:firebase_core/firebase_core.dart';
import 'package:firefly_user/firebase_options.dart';
import 'package:firefly_user/pages/onboarding/main.dart';
import 'package:firefly_user/providers/building.dart';
import 'package:firefly_user/providers/node.dart';
import 'package:firefly_user/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => NodeProvider()),
        ChangeNotifierProvider(create: (context) => BuildingProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Colors.red,
            secondary: Color(0xFF03DAC6),
            surface: Colors.white,
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Color(0xFF000000),
            onSurface: Colors.black,
            onError: Color(0xFFFFFFFF),
          ),
          useMaterial3: true,
        ),
        home: const OnboardingPage(),
      ),
    );
  }
}
