import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pruebaappflutter/views/check.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _identificationController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _termsAccepted = false;

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

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      final String name = _nameController.text.trim();
      final String identification = _identificationController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      if (name.isEmpty ||
          identification.isEmpty ||
          email.isEmpty ||
          password.isEmpty) {
        // Show an error message if any of the fields are empty
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the fields.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      if (!_termsAccepted) {
        // Show an error message if terms and conditions are not accepted
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please accept the terms and conditions.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Save user information to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'identification': identification,
          'email': email,
        });

        Get.to(RegistrationSuccessPage());
      }
    } catch (e) {
      // Show an error message if registration fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Registration failed. Please try again.'),
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
              'Regístrate',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Solo te tomará unso minutos.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration:
                  _createInputDecoration('Nombre completo', Icons.person),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _identificationController,
              decoration:
                  _createInputDecoration('Identificación', Icons.account_box),
            ),
            SizedBox(height: 12),
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
                  value: _termsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _termsAccepted = value ?? false;
                    });
                  },
                ),
                Text('Acepto los términos y condiciones.'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUpWithEmailAndPassword,
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
                'Continuar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the login page when the text is tapped
                // Replace 'LoginPage()' with the actual route to your login page.
                Get.to(LoginPage());
              },
              child: Text(
                '¿Ya tienes una cuenta? Inicia sesión',
                style:
                    TextStyle(color: Colors.blue), // Set the text color to blue
              ),
            ),
          ],
        ),
      ),
    );
  }
}
