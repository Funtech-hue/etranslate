import 'package:etranslate/services/TranslationProvider.dart';
import 'package:etranslate/ult/navBar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TranslationProvider())],
      child: MaterialApp(
        title: 'e-Translator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.green),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => GetStarter()),
      );
    });
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 250),
            Lottie.asset(
              'assets/animations/eSplash.json',
              repeat: true,
              animate: true,
              reverse: true,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 15),
            Text(
              'Translating Anywhere Everywhere',
              style: TextStyle(fontSize: 20),
            ),
            Spacer(),
            Lottie.asset(
              'assets/animations/eLoading.json',
              repeat: true,
              height: 80,
              width: 80,
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class GetStarter extends StatelessWidget {
  const GetStarter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset(
            'assets/animations/eillustration.json',
            repeat: true,
            reverse: true,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 20)),
                backgroundColor: WidgetStatePropertyAll(Colors.green),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 10),
                ),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => navBar()),
                );
              },
              label: Text('Get Starter', style: TextStyle(fontSize: 20)),
              icon: Icon(Icons.arrow_forward_ios_sharp),
            ),
          ),
        ],
      ),
    );
  }
}
