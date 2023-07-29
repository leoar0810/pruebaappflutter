import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
            ),
            items: [
              'https://wallpapercave.com/wp/wp5970199.jpg', // URL of the first image
              'https://images.unsplash.com/photo-1495314736024-fa5e4b37b979?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE0fHx8ZW58MHx8fHx8&w=1000&q=80', // URL of the second image
            ].map((item) => Image.network(item, fit: BoxFit.cover)).toList(),
          ),
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Accede a créditos con un solo toque sin complicaciones.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: onSignInPressed,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Set the button color to white
                      onPrimary: Colors.black, // Set the text color to black
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust the button corner radius
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 16), // Adjust the button height
                    ),
                    child: Text('Ingresar'),
                  ),
                  SizedBox(height: 16), // Adjust the space between the buttons
                  ElevatedButton(
                    onPressed: onSignUpPressed,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Set the button color to blue
                      onPrimary: Colors.white, // Set the text color to white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust the button corner radius
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 16), // Adjust the button height
                    ),
                    child: Text('Registrarme'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
