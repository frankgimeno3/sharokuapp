  import 'package:firebase_core/firebase_core.dart';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
  import 'package:flutter_firebase/features/app/splash_screen/splash_screen.dart';
  import 'package:flutter_firebase/features/user_auth/presentation/pages/home_page.dart';
  import 'package:flutter_firebase/features/user_auth/presentation/pages/login_page.dart';
  import 'package:flutter_firebase/features/user_auth/presentation/pages/sign_up_page.dart';
  import 'package:flutter_firebase/features/user_auth/presentation/pages/task_list.dart';
  import 'package:flutter_firebase/features/user_auth/presentation/pages/calendar.dart';
  import 'package:flutter_dotenv/flutter_dotenv.dart';

  Future main() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: dotenv.env['API_KEY'],
          appId: dotenv.env['APP_ID'],
          messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'],
          projectId: dotenv.env['PROJECT_ID'],
          // Your web Firebase config options
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase',
        routes: {
          '/': (context) => const SplashScreen(
            // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
            child: LoginPage(),
          ),
          '/login': (context) => const LoginPage(),
          '/signUp': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
          '/task_list': (context) => const TaskListPage(),
          '/calendar': (context) => const CalendarPage(),
        },
      );
    }
  }