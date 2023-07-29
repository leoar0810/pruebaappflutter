import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'showtables.dart';

import '../controllers/CreditSimulationController.dart';
import 'creditTable.dart';

class CreditSimulationPage extends StatelessWidget {
  final CreditSimulationController _controller =
      Get.put(CreditSimulationController());
  final TextEditingController _loanController = TextEditingController();

  Future<String> _getUsernameFromFirestore() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String userId =
        user!.uid; // Replace this with the actual user ID or user identifier
    String username = '';

    try {
      // Replace 'users' with the actual collection name where user data is stored
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();
      print("dsfdsfd");
      // Assuming your user data document in Firestore has a 'username' field
      if (snapshot.exists) {
        username = snapshot.data()!['name'] ?? '';
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      print('Error fetching username: $e');
    }

    return username;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      // Bank icon
                      SizedBox(width: 8),
                      Text(
                        'Simulador de crédito', // Bank text
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      FutureBuilder<String>(
                        future: _getUsernameFromFirestore(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While waiting for the data to load, you can show a loading indicator
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            // If there's an error, handle it accordingly
                            return Text('Error loading username');
                          } else {
                            String username = snapshot.data ?? '';
                            return Text(
                              'Hola $username',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  // Display "Hola" and the username from Firestore
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Ingresa los datos para tu crédito según lo que necesites.',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 32),
              DropdownButtonFormField<String>(
                value: _controller.selectedCreditType.value,
                items: [
                  'Crédito Vehículo',
                  'Crédito Vivienda',
                  'Crédito de Libre Inversión'
                ]
                    .map((creditType) => DropdownMenuItem<String>(
                        value: creditType, child: Text(creditType)))
                    .toList(),
                onChanged: (value) {
                  _controller.selectedCreditType.value = value ?? '';
                },
                decoration:
                    _createInputDecoration('Tipo de crédito', Icons.money),
              ),
              SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _controller.baseSalary.value = double.tryParse(value) ?? 0.0;
                  if (value.isEmpty) {
                    _loanController.text = '0';
                    _controller.baseSalary.value = 10;
                  } else {
                    _loanController.text =
                        (double.tryParse(value)! * 7 / 0.15).toStringAsFixed(2);
                    _controller.loanAmount.value =
                        (double.tryParse(value)! * 7 / 0.15);
                  }
                },
                decoration: _createInputDecoration('Salario Base', Icons.money),
              ),
              SizedBox(height: 12),
              TextFormField(
                enabled: false,
                controller: _loanController,
                decoration:
                    _createInputDecoration('Valor del préstamo', Icons.money),
              ),
              SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _controller.loanMonths.value = int.tryParse(value) ?? 0;
                },
                decoration: _createInputDecoration(
                    'Número de meses', Icons.calendar_today),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Home button onPressed
                  if (_controller.loanMonths.value >= 12 &&
                      _controller.loanMonths.value <= 84) {
                    _controller.calculateAmortizationTable();
                    Get.to(AmortizationTablePage());
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text(
                            'El número de meses debe estár en el rango de 12 a 84'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
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
                  'Simular',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // Home button onPressed
                  Get.to(CreditSimulationPage());
                },
              ),
              IconButton(
                icon: Icon(Icons.history),
                onPressed: () {
                  // History button onPressed
                  Get.to(SavedTablesPage());
                },
              ),
            ],
          ),
        ));
  }
}
