import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'feature/Auth/SignIn/Screen/sign_in.dart';
import 'feature/Auth/SignUp/Screen/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dayle Planner',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/sign_in': (context) => const LoginPage(),
        '/sign_up': (context) => const RegisterPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/icons/Icon.png'),
              width: 200,
              height: 200,
            ),
            Text(
              'Dayle Planner.',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'FredokaOne',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
