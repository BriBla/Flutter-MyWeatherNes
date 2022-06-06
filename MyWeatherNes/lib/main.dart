import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(
            seconds: 3,
            navigateAfterSeconds: const MyHomePage(),
            title: const Text(
              'Bienvenue sur MyWeatherNes',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
            image: Image.asset('assets/images/icon.png'),
            backgroundColor: Colors.red,
            styleTextUnderTheLoader: const TextStyle(),
            loaderColor: Colors.white));
  }
}
