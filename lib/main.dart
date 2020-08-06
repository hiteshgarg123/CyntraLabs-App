import 'package:cyntralabs_challenge_app/pages/landing_page.dart';
import 'package:cyntralabs_challenge_app/services/auth.dart';
import 'package:cyntralabs_challenge_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        Provider<AuthBase>(
          create: (context) => Auth(),
        ),
        Provider<FirestoreService>(
          create: (context) => FirestoreService(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.indigo),
        debugShowCheckedModeBanner: false,
        title: 'CyntraLabs App',
        home: LandingPage(),
      ),
    );
  }
}
