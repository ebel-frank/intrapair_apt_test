import 'package:flutter/material.dart';
import 'package:intrapair_mobile_apt_test/screens/home.dart';

void main() {
  runApp(MaterialApp(
    title: 'Intrapair Mobile Apt Test',
    theme: ThemeData(
      fontFamily: 'Satoshi',
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF345035)),
      useMaterial3: true,
    ),
    home: const HomeScreen(),
  ));
}

