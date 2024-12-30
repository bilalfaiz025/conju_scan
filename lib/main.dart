import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/splash_screen.dart';
import 'package:conju_app/viewModel/prediction_vm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCioZxk9wx5xqTW4NxhMwxHUvpnvIYSeUQ",
          appId: "1:652411098676:android:5f2cee76facfc003d15c61",
          messagingSenderId: "652411098676",
          storageBucket: "new1-60139.appspot.com",
          projectId: "new1-60139"));
  runApp(ChangeNotifierProvider(
      create: (_) => PredictionViewModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
