import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'creditoSimulation.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberUser = false;

  InputDecoration _createInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon), // Add the icon as the prefix icon
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
    );
  }

  Future<void> _loginWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        Get.to(CreditSimulationPage());
      } else {
        // Show an error message if email or password is empty
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please enter both email and password.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Show an error message if login fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid email or password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _forgotPassword() {
    // Implement the password recovery logic here
    // For example, show a dialog or navigate to a password recovery screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Olvidaste tu contraseña'),
        content: Text('Funcionalidad por implementar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance), // Bank icon
                SizedBox(width: 8),
                Text(
                  'Banca Créditos', // Bank text
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Inicia sesión o continua, solo te tomará unos minutos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _createInputDecoration('Email', Icons.email),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: _createInputDecoration('Contraseña', Icons.lock),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _rememberUser,
                  onChanged: (value) {
                    setState(() {
                      _rememberUser = value ?? false;
                    });
                  },
                ),
                Text('Recordar al usuario'),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _forgotPassword,
                child: Text('Olvidé mi contraseña'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithEmailAndPassword,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Set the button color to blue
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8.0), // Add rounded corners
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 16.0), // Increase vertical padding
                minimumSize: Size(double.infinity,
                    48.0), // Make the button occupy all horizontal space
              ),
              child: Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                // Navigate to the login page when the text is tapped
                // Replace 'LoginPage()' with the actual route to your login page.
                Get.to(SignUpPage());
              },
              child: Text('¿No Tienes una cuenta? Registrate'),
            ),
          ],
        ),
      ),
    );
  }
}
