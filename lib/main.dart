import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:phonebookonline/screens/homescreen.dart';
import 'package:phonebookonline/screens/licensescreen.dart';
import 'package:phonebookonline/utils/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

Future<bool> getStatus() async {
  final bool isActive;
  final prefs = await SharedPreferences.getInstance();
  //isActive = await prefs.remove('isActive');
  isActive = prefs.getBool('isActive') ?? false;

  return isActive;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Network.checkInternet(context);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'دفترچه تلفن آنلاین',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'iransans'),
        home: FutureBuilder(
          future: getStatus(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return const HomeScreen();
            } else {
              return const LicenseScreen();
            }
          },
        ));
  }
}
