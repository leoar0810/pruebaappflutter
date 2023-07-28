import 'package:flutter/material.dart';

class SignInSignUpView extends StatelessWidget {
  final VoidCallback onSignInPressed;
  final VoidCallback onSignUpPressed;

  SignInSignUpView({
    required this.onSignInPressed,
    required this.onSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In / Sign Up')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your content for the main view can go here.
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: onSignInPressed,
                child: Text('Sign In'),
              ),
              ElevatedButton(
                onPressed: onSignUpPressed,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
