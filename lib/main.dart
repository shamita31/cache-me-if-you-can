import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pawcrastinot/helper/helper_function.dart';
import 'package:pawcrastinot/pages/Login_Page.dart';
import 'package:pawcrastinot/pages/MY_home_Page.dart';
import 'package:pawcrastinot/pages/home_Page.dart'; // Import HomePage
import 'package:pawcrastinot/shared/webOptions.dart';
import 'package:flutter/animation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: WebOptions.apiKey,
            appId: WebOptions.apiId,
            messagingSenderId: WebOptions.messagingSenderId,
            projectId: WebOptions.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _isSignedIn ? HomePage() : MyHomePage() // Ensure HomePage is shown when signed in
    );
  }
}
