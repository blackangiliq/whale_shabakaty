import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habkty_whale/Mobile_Screens/mobile_main_Screen.dart';
import 'package:habkty_whale/Tv_Screens/Tv_main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set preferred orientation to landscape

  // Enable immersive mode (hides system UI)
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildPage(context),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      return Tv_main_Screen();
    } else {
      return CinemaMainScreen();
    }
  }
}
