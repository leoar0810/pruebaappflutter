import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'creditoSimulation.dart';

class RegistrationSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'Registro Exitoso',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Hemos guardado tus credenciales de forma exitosa.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(CreditSimulationPage());
              },
              child: Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
