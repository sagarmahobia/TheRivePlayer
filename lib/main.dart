import 'package:flutter/material.dart';
import 'package:the_rive_player/home/home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rive Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       brightness: Brightness.dark,

        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}
