import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../SignIn/Screen/sign_in.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obsecureTextPassword = true;
  bool _obsecureTextConfirmPassword = true;
  String _errorMessages = '';
  String _success = '';

  Future<void> _register() async {
    final String firstName = _firstNameController.text;
    final String lastName = _lastNameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    setState(() {
      if (firstName.isEmpty ||
          lastName.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        _errorMessages = 'All fields are required.';
      } else if (password.length < 6) {
        _errorMessages = 'Password must be at least 6 characters.';
      } else if (password != confirmPassword) {
        _errorMessages = 'Password does not match.';
      } else {
        _errorMessages = '';
        _success = 'Registering...';
      }
    });
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'phone': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      setState(() {
        _success = 'Registration successful!';
      });
      // Navigate to the main app screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      debugPrint('error: $e');
      setState(() {
        _success = '';
        _errorMessages = 'Registration failed: $e';
      });
    }
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/Icon.png',
                      width: 100,
                      height: 100,
                    ),
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'FredokaOne',
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _errorMessages,
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      _success,
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
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
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
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
                      obscureText: _obsecureTextPassword,
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
                              _obsecureTextPassword = !_obsecureTextPassword;
                            });
                          },
                          icon: Icon(_obsecureTextPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obsecureTextConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
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
                              _obsecureTextConfirmPassword =
                                  !_obsecureTextConfirmPassword;
                            });
                          },
                          icon: Icon(_obsecureTextConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () => _register(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 37,
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
                        child: const Text('Register')),
                    const SizedBox(width: 7),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_in');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 37,
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
                      child: const Text('Cancel'),
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
