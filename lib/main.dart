import 'package:flutter/material.dart';
import 'package:map/map/banner.dart';
import 'package:map/map/map_screen.dart';

void main() {
  runApp(SplashScreenHome());
}

class MyMap extends StatelessWidget {
  const MyMap({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
      title: 'Map-OpenStreetMap',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
