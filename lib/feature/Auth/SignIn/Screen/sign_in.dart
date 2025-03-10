import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/App/app.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obsecureText = true;
  String _errorMessages = '';
  String _success = '';

  Future<void> signInWithGoogle() async {
    setState(() {
      _errorMessages = '';
      _success = 'Signing in with Google...';
    });

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      debugPrint("google user: $googleUser");

      if (googleUser == null) {
        setState(() {
          _success = '';
          _errorMessages = 'Google sign in cancelled';
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        setState(() {
          _success = '';
          _errorMessages = 'Google authentication failed: Tokens are null';
        });
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("Cred: $userCredential");
      
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'firstname': googleUser.displayName?.split(' ').first ?? '',
          'lastname': googleUser.displayName?.split(' ').last ?? '',
          'email': googleUser.email,
          'phone': null,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      setState(() {
        _success = 'Google sign in successful!';
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const App(),
          ),
        );
      }
    } catch (e) {
      debugPrint('=================================');
      debugPrint('====== Error: $e');
      debugPrint('=================================');
      setState(() {
        _success = '';
        _errorMessages = 'Google sign in failed: $e';
      });
    }
  }

  Future<void> _signin(String email, String password) async {
    setState(() {
      if (email.isEmpty || password.isEmpty) {
        _errorMessages = 'Please fill in all fields.';
        return;
      }
      _errorMessages = '';
      _success = 'Signing in...';
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() {
        _success = 'Sign in successfull!';
      });

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const App(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _success = '';
        if (e.code == 'user-not-found') {
          _errorMessages = 'Invalid login.';
        } else if (e.code == 'wrong-password') {
          _errorMessages = 'Invalid login.';
        } else {
          _errorMessages = 'Sign in failed.';
        }
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        _errorMessages = 'Error: $e';
      });
    }
  }

  void _signup(String email, String password) {
    Navigator.pushNamed(context, '/sign_up');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/Icon.png',
                width: 100,
                height: 100,
              ),
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'FredokaOne',
                  color: Colors.black,
                ),
              ),
              Text(
                _errorMessages,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontFamily: 'Arial',
                ),
              ),
              Text(
                _success,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontFamily: 'Arial',
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontFamily: 'AntipastoPro',
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obsecureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          fontFamily: 'AntipastoPro',
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obsecureText = !_obsecureText;
                            });
                          },
                          icon: Icon(_obsecureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  debugPrint('Forgot password?');
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontFamily: 'AntipastoPro',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _signin(
                          _emailController.text, _passwordController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 18,
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'FredokaOne',
                          fontSize: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                      ),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () => _signup(
                          _emailController.text, _passwordController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 18,
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'FredokaOne',
                          fontSize: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Or sign in with',
                style: TextStyle(
                  fontFamily: 'AntipastoPro',
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: signInWithGoogle,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/google.png',
                                width: 40, height: 40),
                            const Text(
                              ' Sign in with Google',
                              style: TextStyle(
                                fontFamily: 'AntipastoPro',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/message.png',
                                width: 40, height: 40),
                            const Text(
                              ' Sign in with Phone',
                              style: TextStyle(
                                fontFamily: 'AntipastoPro',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
